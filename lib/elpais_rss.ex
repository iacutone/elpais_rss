defmodule ElpaisRss do
  @moduledoc """
  All-encompassing run/0 function for `ElpaisRss`.
  """

  alias ElpaisRss.Article
  alias ElpaisRss.Email

  @doc "Email the first most viewed RSS article entry to MailChimp client list via AWS SES"
  def run do
    article = Article.fetch()
    emails = Email.fetch()

    if Email.send(article, emails) == :ok do
      HTTPoison.get("https://cronhub.io/ping/9b7e1860-7ffb-11ea-83b7-11422ae8ff81")
    end
  end
end
