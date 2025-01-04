defmodule ElpaisRss.Email do
  @moduledoc """
  Retrieve emails from provider and email clients
  """

  @auth System.fetch_env!("MAILCHIMP_API_KEY")
  @endpoint "https://us13.api.mailchimp.com/3.0/lists/208637560c/members"

  @doc "Fetch subscriber emails from MailChimp"
  def fetch do
    {:ok, %{body: body}} = HTTPoison.get(@endpoint, headers())
    {:ok, %{"members" => members}} = Jason.decode(body)

    Enum.reduce(members, [], fn
      %{"status" => "subscribed", "email_address" => email}, acc ->
        [email | acc]

      _, acc ->
        acc
    end)
  end

  @doc "Send emails with AWS SES"
  def send(article, emails) do
    %{title: title, text: text} = article

    Enum.each(emails, fn email ->
      ExAws.SES.send_email(
        %{to: [email], bcc: [], cc: []},
        %{
          body: %{text: %{data: text, charset: "UTF-8"}},
          subject: %{data: String.slice(title, 0..45) <> "...", charset: "UTF-8"}
        },
        "hello@masterspanish.today"
      )
      |> ExAws.request(
        access_key_id: System.fetch_env!("AWS_ACCESS_KEY"),
        secret_access_key: System.fetch_env!("AWS_SECRET_KEY")
      )
    end)

    :ok
  end

  defp headers do
    credentials_encoded = Base.encode64("anystring:#{@auth}")

    [{"Authorization", "Basic #{credentials_encoded}"}]
  end
end
