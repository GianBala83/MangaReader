defmodule WorkPage do
  @link "<a href='http://localhost:8000/chapts/"

  def chat_refs([]), do: ""

  def chat_refs(work, chapts) do
    gera_link(work, chapts)
  end

  defp gera_link(_work, []), do: ""

  defp gera_link(work, [[cap, pag] | resto]) do
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

  def create_work(work) do

    work_new = String.replace(work, "_", " ")
    local_infos = Information.get_file_infomation(work)

    id = local_infos["id"]
    chapts = local_infos["chapts"]
    chapt_string = chat_refs(work_new, chapts)
    infos = get_api_information(id)
    text = Tradutor.traduzir_partes(Texto.texto_limite(infos["synopsis"]))

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
      '<h2>#{text}</h2>',
      '#{chapt_string}',
      '</body>',
      '</html>' ]

  end
end
