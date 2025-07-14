defmodule ElpaisRss.Translate do
  @moduledoc """
  Translate Spanish text into English
  """

  @model_url "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"

  @doc "Translate a given corpus of text with Google Gemini LLM"
  def translate(text) do
    body = %{
      "system_instruction" => %{
        "parts" => [
          %{
            "text" =>
              "Can you translate the following text exactly without any additional comments?, Additionally, can you intersperse the Spanish translation and the translated English text?"
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
        headers: [{"x-goog-api-key", gemeni_api_key()}],
        method: :post,
        receive_timeout: :timer.seconds(1_500),
        url: @model_url
      )

    case Req.Request.run_request(req) do
      {_req, %{body: %{"candidates" => [%{"content" => %{"parts" => [%{"text" => text}]}}]}}} ->
        text

      error ->
        IO.inspect(error)
        nil
    end
  end

  defp gemeni_api_key do
    Application.fetch_env!(:elpais_rss, :google_gemini_api_key)
  end
end
