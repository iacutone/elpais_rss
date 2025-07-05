defmodule ElpaisRss.Translate do
  @moduledoc """
  Translate Spanish text into English
  """

  @gemeni_api_key System.fetch_env!("GOOGLE_GEMINI_API_KEY")

  @doc "Translate a given corpus of text with Google Gemini LLM"
  def translate(text) do
    body = %{
      "system_instruction" => %{
        "parts" => [
          %{
            "text" =>
              "Can you translate the following text exactly without any additional comments?"
          }
        ]
      },
      "contents" => [
        %{
          "parts" => [
            %{
              "text" => text
            }
          ]
        }
      ]
    }

    req =
      Req.new(
        body: Jason.encode!(body),
        headers: [{"x-goog-api-key", @gemeni_api_key}],
        method: :post,
        url:
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"
      )

    case Req.Request.run_request(req) do
      {_req, %{body: %{"candidates" => [%{"content" => %{"parts" => [%{"text" => text}]}}]}}} ->
        text

      _ ->
        nil
    end
  end
end
