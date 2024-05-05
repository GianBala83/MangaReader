defmodule Http do
  def pick_image_title() do
    {:ok,x} = File.read("lib/data/fig4.png")
    imagem_base64 = Base.encode64(x)
    '<td colspan="7" style="text-align: center;"><img src="data:image/jpeg;charset=utf-8;base64,#{imagem_base64}" style = "width: 800px;"></td>'
  end
  def pick_images_covers(_cont,str,[]), do: str
  def pick_images_covers(cont,str,list) do
    cont = cont + 1
    elemento = hd(list)
    path = elemento["path"]
    capa = elemento["url_image"]
    case cont do
      1 ->
        str = str <>"""
                <tr>
                        <td>
                            <a href = "http://localhost:8000/work/#{path}">
                                <img src="#{capa}" class = "imagem">
                            </a>
                        </td>
           """
      pick_images_covers(cont,str,tl(list))
      7 ->
        str = str <>"""
                        <td>
                            <a href = "http://localhost:8000/work/#{path}">
                                <img src="#{capa}" class = "imagem">
                            </a>
                        </td>
                </tr>
           """
      pick_images_covers(cont,str,tl(list))
      _ ->
        str = str <>"""
                        <td>
                            <a href = "http://localhost:8000/work/#{path}">
                                <img src="#{capa}" class = "imagem">
                            </a>
                        </td>
           """
      pick_images_covers(cont,str,tl(list))
    end
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
    mangas = pick_images_covers(0,"",capas)
    index = [
      """
          <!DOCTYPE html>
          <html lang="pt-br">
          <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>Manga Reader</title>
              <style>
                  /* Estilos opcionais */
                  table {
                      border-collapse: collapse;
                      width: 100%;

                  }
                  th, td {
                      /*border: 1px solid black;*/
                      padding: 8px;
                      text-align: center;
                  }
                  .imagem{
                      width: 300px;
                      height: 533px;
                      max-width: 100%; /* Garante que a imagem não ultrapasse a largura da coluna */
                      height: auto; /* Mantém a proporção da imagem */
                      display: block; /* Remove espaços em branco indesejados */
                      margin-left: 40px;
                  }
                  body{
                      justify-content: center; /* Centraliza no eixo horizontal */
                      align-items: center;
                      margin: 0 auto;
                      display: flex;
                      height: 80vh;
                  }
              </style>
          </head>
          <body>

          <table style = "margin-top: 80px;">

              <tr>
                  #{title_image}
              </tr>
                #{mangas}
          </table>

          </body>
          </html>
"""
    ]
    resp200(index)
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
