defmodule Tradutor do
  defp traduzir(texto) do
    url = "https://api.mymemory.translated.net/get"
    corpo = %{q: texto, langpair: "en|pt"} |> URI.encode_query()
    url_com_parametros = "#{url}?#{corpo}"

    case HTTPoison.get(url_com_parametros) do
      {:ok, %HTTPoison.Response{status_code: 200, body: corpo_resposta}} ->
        corpo_resposta |> Jason.decode!() |> Map.get("responseData") |> Map.get("translatedText")
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        IO.puts("Erro: #{status_code}")
      {:error, %HTTPoison.Error{reason: motivo}} ->
        IO.puts("Erro: #{motivo}")
    end
  end

  def traduzir_partes([]), do: ""
  def traduzir_partes([texto | resto]), do: traduzir(texto) <> " " <> traduzir_partes(resto)
end
