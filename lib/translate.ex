defmodule ElpaisRss.Translate do
  @moduledoc """
  Translate Spanish text into English
  """

  @doc "Translate a given corpus of text"
  def translate(text) do
    token = Goth.fetch!(ElpaisRss.Goth).token
    conn = GoogleApi.Translate.V2.Connection.new(token)

    req = %GoogleApi.Translate.V2.Model.TranslateTextRequest{
      format: "text",
      model: "nmt",
      q: text,
      source: "es",
      target: "en"
    }

    case GoogleApi.Translate.V2.Api.Translations.language_translations_translate(conn, body: req) do
      {:ok, %{translations: [%{translatedText: text} | _]}} ->
        text

      _ ->
        nil
    end
  end
end
