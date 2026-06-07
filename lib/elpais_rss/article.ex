defmodule ElpaisRss.Article do
  @moduledoc """
  Retrieve the latest article
  """

  @doc "Fetch the first RSS entry's id and summarize the article text"
  def fetch do
    headers = [
      {"User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36"},
      {"Accept", "application/rss+xml, application/xml, text/xml, */*"},
      {"Accept-Language", "en-US,en;q=0.9,es;q=0.8"},
      {"Accept-Encoding", "gzip, deflate, br"},
      {"Cache-Control", "no-cache"},
      {"Pragma", "no-cache"}
    ]

    with {:ok, %{body: body}} <- Req.get(url(), headers: headers),
         {:ok, %{entries: [%{id: id} | _]}, _} <- FeederEx.parse(body),
         %{title: title, article_text: article_text} <- Readability.summarize(id) do
      translated_text = ElpaisRss.Translate.translate(article_text)
      %{title: title, text: compose_article_text(article_text, translated_text)}
    end
  end

  defp compose_article_text(article_text, nil), do: article_text <> unsubscribe_link()

  defp compose_article_text(_article_text, translated_text) do
    translated_text <> unsubscribe_link()
  end

  defp unsubscribe_link do
    ~S"""


    Unsubscribe: https://amazonaws.us13.list-manage.com/unsubscribe?u=93b41a1871734324d088abc68&id=208637560c
    """
  end

  defp url do
    Application.fetch_env!(:elpais_rss, :el_pais_rss_url)
  end
end
