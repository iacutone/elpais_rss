defmodule ElpaisRss do
  @moduledoc """
  All-encompassing run/0 function for `ElpaisRss`.
  """

  alias ElpaisRss.Article
  alias ElpaisRss.Email

  @doc "Email the first most viewed RSS article entry to MailChimp client list via AWS SES"
  def run do
    with article when is_map(article) <- Article.fetch(),
         emails when is_list(emails) <- Email.fetch(),
         :ok <- Email.send(article, emails) do
      Req.get!(Application.fetch_env!(:elpais_rss, :cronhub_url))
    end
  end
end
