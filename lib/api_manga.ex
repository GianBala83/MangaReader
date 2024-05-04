defmodule API_Manga do
  @spec request(any()) :: any()
  def request (manga_id) do
    url = "https://api.jikan.moe/v4/manga/#{manga_id}/full"
    res = HTTPoison.get(url)
		{:ok, res_prs }= information_process(res)
    {:ok, api_map} = Poison.decode(res_prs)
    api_map["data"]
	end


	def information_process ({:ok, %HTTPoison.Response{ status_code: 200, body: b}}) do
    {:ok, b}
	end

	def information_process ({ :error, r}) do
     {:error, r}
	end

	def information_process ({:ok, %HTTPoison.Response{ status_code: _, body: b}}) do
    {:erro, b}
	end

end
