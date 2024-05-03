defmodule WorkPage do
  @link "<a href='http://localhost:8000/chapts/"

  def chat_refs(work) do
    # Aqui a gente precisa buscar quais capitulos estão disponiveis em algum lugar
    #
    case work do
      "Edens Zero" ->
        gera_link(work, [{100, 20}])
      "One Piece" ->
        gera_link(work, [{3, 21}, {4, 20}, {1000, 14}])
      _ ->
        """
        <h2> Nenhum Capitulo Encontrado!</h2>
        """
      end

  end

  defp gera_link(_work, []), do: ""

  defp gera_link(work, [{cap, pag} | resto]) do
    @link <> "#{String.replace(work, " ", "_")}/#{cap}$#{pag}'>Capítulo #{cap}</a><br>" <> gera_link(work, resto)
  end

  def get_api_information(id) do
    j_dir = API_Manga.request(id)

    img = j_dir["images"]
    img_j = img["jpg"]

    #IO.puts j_dir["synopsis"]
    %{"capa" => img_j["large_image_url"],
      "title" => j_dir["title"],
      "synopsis" => j_dir["synopsis"]
    }

  end

  def create_work(work, id) do

    work = String.replace(work, "_", " ")
    #chapt = ""
    chapt = chat_refs(work)
    infos = get_api_information(id)

    IO.puts infos[":synopsis"]

    [ '<!DOCTYPE html>',
      '<html lang="en">',
      '<head>',
      '<meta charset="UTF-8">',
      '<meta name="viewport" content="width=device-width, initial-scale=1.0">',
      '<style>',
      'a {',
      'color: green',
      '}',
      'body {',
      'font-family:Arial;',
      'color: white;',
      'background-color:black;',
      '}',
      'h1 {',
      'font-family:Arial;',
      'font-size: 36pt;',
      'color: white;',
      'text-align: center;',
      '}',
      '</style>',
      '<title>#{work}</title>',
      '</head>',
      '<body>',
      '<h1>#{work}</h1>',
      '<img src=#{infos["capa"]}> </img>',
      '<h2>#{infos["synopsis"]}</h2>',
      '#{chapt}',
      '</body>',
      '</html>' ]

  end
end
