defmodule ElpaisRss.Article do
  @moduledoc """
  Retrieve the latest article
  """

  @doc "Fetch the first RSS entry's id and summarize the article text"
  def fetch do
    with {:ok, %{body: body}} <- Req.get(url()),
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
