defmodule WorkPage do
  @link "<a href='http://localhost:8000/chapts/"

  def get_genres(str, []), do: str
  def get_genres(str, lista) do
    ele = hd(lista)
    str = str <> ele["name"] <> "/"
    get_genres(str, tl(lista))
  end

  def get_api_information(id) do
    j_dir = API_Manga.request(id)

    img = j_dir["images"]
    img_j = img["jpg"]
    au = hd(j_dir["authors"])
    au = au["name"]
    gens = get_genres("", j_dir["genres"])
    IO.puts gens

    #IO.puts j_dir["synopsis"]
    %{"capa" => img_j["large_image_url"],
      "title" => j_dir["title"],
      "synopsis" => j_dir["synopsis"],
      "nota" => j_dir["score"],
      "autor" => au,
      "generos" => gens
    }
  end

  def chat_refs([]), do: ""
  def chat_refs(work, chapts) do
    gera_link(work, chapts)
  end

  defp gera_link(_work, []), do: ""
  defp gera_link(_work, nil), do: ""
  defp gera_link(work, [cap | resto]) do
    @link <> "#{String.replace(work, " ", "_")}/#{cap}'>Capítulo #{cap}</a>" <> gera_link(work, resto)
  end

  def create_work(work) do

    work_new = String.replace(work, "_", " ")
    local_infos = Information.get_file_infomation(work)

    id = local_infos["id"]
    chapts = local_infos["chapts"]
    chapt_string = chat_refs(work_new, chapts)
    infos = get_api_information(id)

    # Está acontecendo algum erro por aqui
    # Obs Respeitar o limite de chars por dia na tradução.
    title = infos["title"]
    text = infos["synopsis"]
    nota = infos["nota"]
    autor = infos["autor"]
    generos = infos["generos"]

    #text = Tradutor.traduzir_partes(Texto.texto_limite(infos["synopsis"]))

    # ! HTML !
    [
      '<!DOCTYPE html>',
      '<html lang="en">',
      '<head>',
      '<meta charset="UTF-8">',
      '<meta name="viewport" content="width=device-width, initial-scale=1.0">',
      '<style>',

      'a {',
        'font-size: 22pt;',
        'color: white;',
        'visited: white;',
        'font-weight: bold;',
        'text-decoration:none;',
      '}',

      'body {',
        'font-family:Segoe Print;',
        'color: white;',
        'background-color:black;',
      '}',

      'h1 {',
        'font-family:Arial;',
        'font-size: 36pt;',
        'color: white;',
        'text-align: center;',
      '}',


      """
      h3 {
        'border: 4px solid white;',
      }
      """,

      """
      #maininfo {
        display: flex;
      }
      """,

      """
      #maininfo2 {
        display: flex;
        justify-content: center;
        align-items: center;
      }
      """,

      """
      #img {
        width:600px;
        height:650px;
        margin-left: 2%;
        border: 8px solid blue;
        display: flex;
        justify-content: center;
        align-items: center;
      }
      """,

      """
      #infos {
        width:600px;
        height:650px;
        margin-left: 2%;
        font-size: 8pt;
        border: 8px;
		    border-color: white;
		    border-style: double;
        overflow: scroll;
        overflow-x: hidden';
        overflow-y: hidden';
      }
      """,

      """
      #chapts {
        width:600px;
        height:650px;
        margin-left: 2%;
        border: 8px solid white;
        display: grid;
      }
      """,

      '</style>',

      '<title>#{title}</title>',
      '</head>',

      '<body>',

      #'<h1>#{title}</h1>',

      '<div id="maininfo">',

      '<div id="img">',
      '<img src=#{infos["capa"]}> </img>',
      '</div>',

      """
      <div id="infos">
      <h2>Titulo: #{title}</h2>
      <h2>Autor: #{autor}</h2>
      <h2>Nota: #{nota}</h2>
      <h2>Generos: #{generos}</h2>
      <h2>Sinopse:</h2>
      <h2>#{text}
      </div>
      """,

      '</div>',

      '<div id="maininfo2">',
      '<div id="chapts">',
      '#{chapt_string}',
      '</div>',
      '</div>',

      '</body>',
      '</html>' ]

  end
end
