defmodule Http do

  def get_tiltes(str, []), do: str
  def get_tiltes(str, data) do
    title_current = hd(data)
    str = str <> "<a href='http://localhost:8000/work/" <> title_current <> "'>" <> title_current <> "</a><br>"
    get_tiltes(str, tl(data))
  end

  def gera_resposta (pacote) do
    analisa_req(pacote)
    |> resposta
    |> formata_resposta
    #formata_resposta(@index)
  end

  # Pagina Inicial
  def resposta({"GET", "/"}) do
    data = Information.get_title_infomation()
    titles = get_tiltes("", data)
    IO.puts titles
    index = [
      "<!DOCTYPE html>",
      "<html>",
      "<head>",
      '<style>',
      'body {',
      'font-family:Arial;',
      'color: white;',
      'background-color:black;',
      '}',
      'h1 {',
      'font-family:Segoe Print;',
      'font-size: 36pt;',
      'color: white;',
      'text-align: center;',
      '}',
      '</style>',
      '<meta charset="utf-8"/>',
      "<title>Mangá Reader Elixir</title>",
      "</head>",
      "<body>",
      "<h1>Mangá Reader Elixir - Version 0.8<\h1>",
      "<div>",
      "#{titles}",
      "<div>",
      "</body>",
      "</html>"
    ]
    resp200(index)
  end

  # Pagina dos capítulos
  def resposta({"GET", "/chapts/" <> file}) do
    [path | len] = String.split(file, "$")
    #IO.puts len
    title = String.replace(path, "_", " ")
    title = String.replace(title, "/", " Capítulo ")
    data_path = Information.get_data_path()
    path = data_path <> "chapts/" <> path <> "/"
    len = String.to_integer(hd(len))
    resp200(MangaPage.create_manga_page(path, title, len))
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
