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
    "<div class='chapter-link'>" <> @link <> "#{String.replace(work, " ", "_")}/#{cap}'>Capítulo #{cap}</a></div>" <> gera_link(work, resto)
  end


  def create_work(work) do
    work_new = String.replace(work, "_", " ")
    local_infos = Information.get_file_infomation(work)

    id = local_infos["id"]
    chapts = local_infos["chapts"]
    chapts = chat_refs(work_new, chapts)
    infos = get_api_information(id)

    title = infos["title"]
    text = infos["synopsis"]
    |> Texto.texto_limite
    |> Tradutor.traduzir_partes
    nota = infos["nota"]
    autor = infos["autor"]
    generos = infos["generos"]
    capa = infos["capa"]


    assigns = [
      title: title,
      text: text,
      nota: nota,
      autor: autor,
      generos: generos,
      chapts: chapts,
      infos: infos,
      capa: capa
    ]

    EEx.eval_file("lib/front_end/manga_chapter.html.eex", assigns: assigns)
    |> String.split("\r\n")
  end

end
