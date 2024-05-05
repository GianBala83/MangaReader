defmodule Http do
  def pick_image_title() do
    {:ok, x} = File.read("lib/data/fig4.png")
    imagem_base64 = Base.encode64(x)
    '<td colspan="7" style="text-align: center;"><img src="data:image/jpeg;charset=utf-8;base64,#{imagem_base64}" style="display: block; margin: 0 auto; width: 800px;"></td>'
  end

  def pick_images_covers(list) do
    EEx.eval_file("lib/front_end/capas.html.eex", assigns: [list: list, cont: Enum.count(list)])
  end


  def gera_resposta (pacote) do
    analisa_req(pacote)
    |> resposta
    |> formata_resposta
    #formata_resposta(@index)
  end

  # Pagina Inicial
  def resposta({"GET", "/"}) do
    title_image = pick_image_title()
    capas = Information.get_cover_infomation()
    mangas = pick_images_covers(capas)

    EEx.eval_file("lib/front_end/template.html.eex", [title_image: title_image, mangas: mangas])
    |> String.split("\r\n")
    |> resp200()
  end


  # Pagina dos capítulos
  def resposta({"GET", "/chapts/" <> file}) do
    path = hd(String.split(file, "$"))
    #IO.puts len
    title = String.replace(path, "_", " ")
    title = String.replace(title, "/", " Capítulo ")
    data_path = Information.get_data_path()
    path = data_path <> "chapts/" <> path <> "/"
    resp200(MangaPage.create_manga_page(path, title))
  end

  # Pagina dos Titulos
  def resposta({"GET", "/work/" <> work}) do
    resp200(WorkPage.create_work(work))
  end

  # Pagina 404
  def resposta(_) do
    page404 = [
      "<!DOCTYPE html>",
      "<html>",
      "<head>",
      '<meta charset="utf-8"/>',
      "<title>Not Found</title>",
      "</head>",
      "<body>",
      "<hi>404 - Not Found<\h1>",
      "</body>",
      "</html>"
    ]
    resp404(page404)
  end


  @spec resp200(any()) :: {200, <<_::16>>, any()}
  def resp200(corpo), do: {200, "Ok", corpo}
  def resp404(corpo), do: {404, "Not Found", corpo}

  def analisa_req(pacote)do
    String.split(to_string(pacote), "\r\n")
    |> List.first()
    |> String.split()
    |> Enum.take(2)
    |> List.to_tuple()
  end

  defp resp_inicial(codigo, msg), do: "HTTP/1.1 #{codigo} #{msg}"
  defp respota_http(codigo, msg, corpo) do
    tamanho = byte_size corpo

    [
      resp_inicial(codigo, msg),
      "Content-Type: text/html; charset=utf-8",
      "Content-Lenght: #{tamanho}",
      "",
      corpo
    ]
  end

  def formata_resposta({codigo, msg, corpo})do
    respota_http(codigo, msg, Enum.join(corpo, "\r\n"))
    |> Enum.join("\r\n")
  end

end
