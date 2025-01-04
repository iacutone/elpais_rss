defmodule ElpaisRss.Article do
  @moduledoc """
  Retrieve the latest article
  """

  @url System.fetch_env!("EL_PAIS_RSS_URL")

  @doc "Fetch the first RSS entry's id and summarize the article text"
  def fetch do
    {:ok, %{body: body}} = HTTPoison.get(@url)
    {:ok, %{entries: [%{id: id} | _]}, _} = FeederEx.parse(body)
    %{title: title, article_text: article_text} = Readability.summarize(id)

    translated_text = ElpaisRss.Translate.translate(article_text)

    %{title: title, text: compose_article_text(article_text, translated_text)}
  end

  defp compose_article_text(article_text, nil), do: article_text <> unsubscribe_link()

  defp compose_article_text(article_text, translated_text) do
    zipped = Enum.zip(String.split(article_text, "\n"), String.split(translated_text, "\n"))

    Enum.reduce(zipped, "", fn {original, translated}, acc ->
      acc <> original <> "\n" <> translated <> "\n\n"
    end) <> unsubscribe_link()
  end

  defp unsubscribe_link do
    ~S"""


    Unsubscribe: https://amazonaws.us13.list-manage.com/unsubscribe?u=93b41a1871734324d088abc68&id=208637560c'
    """
  end
end
