defmodule ElpaisRss.Email do
  @moduledoc """
  Retrieve emails from provider and email clients
  """

  @doc "Fetch subscriber emails from MailChimp"
  def fetch do
    with {:ok, %{body: body}} <- HTTPoison.get(Application.fetch_env!(:elpais_rss, :mailchimp_unsubscribe_endpoint), headers()),
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
        access_key_id: Application.fetch_env!(:elpais_rss, :aws_access_key),
        secret_access_key: Application.fetch_env!(:elpais_rss, :aws_secret_key)
      )
    end)
  end

  defp headers do
    credentials_encoded = Base.encode64("anystring:#{auth()}")

    [{"Authorization", "Basic #{credentials_encoded}"}]
  end

  defp auth do
    Application.fetch_env!(:elpais_rss, :mailchimp_api_key)
  end
end
