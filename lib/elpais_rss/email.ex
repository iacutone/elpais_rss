defmodule ElpaisRss.Email do
  @moduledoc """
  Retrieve emails from provider and email clients
  """

  @auth Application.compile_env!(:elpais_rss, :mailchimp_api_key)
  @endpoint "https://us13.api.mailchimp.com/3.0/lists/208637560c/members"

  @doc "Fetch subscriber emails from MailChimp"
  def fetch do
    with {:ok, %{body: body}} <- HTTPoison.get(@endpoint, headers()),
         {:ok, %{"members" => members}} <- Jason.decode(body) do
      Enum.reduce(members, [], fn
        %{"status" => "subscribed", "email_address" => email}, acc ->
          [email | acc]

        _, acc ->
          acc
      end)
    end
  end

  @doc "Send emails with AWS SES"
  def send(article, emails) do
    %{title: title, text: text} = article

    Enum.each(emails, fn email ->
      ExAws.SES.send_email(
        %{to: [email], bcc: [], cc: []},
        %{
          body: %{text: %{data: text, charset: "UTF-8"}},
          subject: %{data: title, charset: "UTF-8"}
        },
        "hello@masterspanish.today"
      )
      |> ExAws.request(
        access_key_id: System.fetch_env!("AWS_ACCESS_KEY"),
        secret_access_key: System.fetch_env!("AWS_SECRET_KEY")
      )
    end)
  end

  defp headers do
    credentials_encoded = Base.encode64("anystring:#{@auth}")

    [{"Authorization", "Basic #{credentials_encoded}"}]
  end
end
