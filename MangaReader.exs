defmodule Socket do
  def servidor(porta) do

    # Criar Socktes
    {:ok, socket} = :gen_tcp.listen(porta, active: false)

    # Aguarda Conexão do Cliente
    IO.puts("Porta da Conexão: #{porta}\n")
    recebe_conexao(socket)

    #Fecha Socket
    :gen_tcp.close(socket)
  end

  def recebe_conexao(socket)do
    # Aceitar Conexão
    {:ok, client} = :gen_tcp.accept(socket)

    # Receber o Request
    {:ok, pacote} = :gen_tcp.recv(client, 0)

    # Enviar a Respost
    resposta = Http.gera_resposta(pacote)
    :gen_tcp.send(client, resposta)

    # fechar Conexão
    :gen_tcp.close(client)

    # Loop Para Conxeão
    recebe_conexao(socket)
  end

end

defmodule Http do

  @index [
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
    'font-family:Arial;',
    'font-size: 36pt;',
    'color: white;',
    'text-align: center;',
    '}',
    '</style>',
    '<meta charset="utf-8"/>',
    "<title>Olá Elixir</title>",
    "</head>",
    "<body>",
    "<h1>Mangá Reader Elixir - Version 0.4.1 - Git<\h1>",
    "<a href='http://localhost:8000/work/Dragon_Ball'>Dragon Ball</a><br>",
    "<a href='http://localhost:8000/work/Edens_Zero'>Edens Zero</a><br>",
    "<a href='http://localhost:8000/work/One_Piece'>One Piece</a><br>",
    "</body>",
    "</html>"
  ]

  @page404 [
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

  def gera_resposta (pacote) do
    analisa_req(pacote)
    |> resposta
    |> formata_resposta
    #formata_resposta(@index)
  end

  def resposta({"GET", "/"}), do: resp200(@index)
  def resposta({"GET", "/chapts/" <> file}) do
    [path | len] = String.split(file, "$")
    IO.puts len
    IO.puts path
    len = String.to_integer(hd(len))
    resp200(MangaPage.create_manga_page("chapts/" <> path <> "/", path, len))
  end
  def resposta({"GET", "/work/" <> work}) do
    resp200(WorkPage.create_work(work))
  end
  def resposta(_), do: resp404(@page404)


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

defmodule WorkPage do
  def chat_refs(work) do
    # Aqui a gente precisa buscar quais capitulos estão disponiveis em algum lugar
    #
    case work do
      "Edens Zero" ->
        """
        <a href='http://localhost:8000/chapts/Edens_Zero/100$20'>Capítulo 100</a><br>
        """
      "One Piece" ->
        """
        <a href='http://localhost:8000/chapts/One_Piece/3$21'>Capítulo 3</a><br>
        <a href='http://localhost:8000/chapts/One_Piece/4$20'>Capítulo 4</a><br>
        <a href='http://localhost:8000/chapts/One_Piece/1000$14'>Capítulo 1000</a><br>
        """
      _ ->
        """
        <h2> Nenhum Capitulo Encontrado!</h2>
        """
      end

  end

  def create_work (work) do

    work = String.replace(work, "_", " ")
    chapt = ""
    chapt = chat_refs(work)

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
      '#{chapt}',
      '</body>',
      '</html>' ]

  end
end

defmodule MangaPage do

  def reader_file(path) do
    {:ok, img} = File.read(path)
    imagem_base64 = Base.encode64(img)
    "<td> <center> <img src='data:image/jpeg;charset=utf-8;base64,#{imagem_base64}'></img>"
  end

  def generate_chapt(l2, path, pgs, len) when pgs <= len do
    path_n = path <> "#{pgs}.jpg"
    l2 = l2 ++ [reader_file(path_n)]
    generate_chapt(l2, path, pgs+1, len)
  end
  def generate_chapt(l2, path, pgs, len) when pgs > len, do: l2


  def create_manga_page(path, t, len) do
    # Retorna a Página Html
    title = t
    l2 = []
    l2 = generate_chapt(l2, path, 1, len)

    l1 = [
      '<!DOCTYPE html>',
      '<html lang="en">',
      '<head>',
      '<meta charset="UTF-8">',
      '<meta name="viewport" content="width=device-width, initial-scale=1.0">',
      '<style>',
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
      '<title>#{title}</title>',
      '</head>',
      '<body>',
      '<h1>#{title}</h1>'
    ]

    l3 = [
      '</body>',
      '</html>'
    ]

    l1 ++ l2 ++ l3
  end

end

# Executar
# Está rodando em loop
Socket.servidor(8000)

# Test para o iex.bat
# Socket.servidor(8000)
# Http.gera_resposta(~c"GET / HTTP 1.1\r\nHost: localhost:8000\r\n\r\n")

#Browser Test
# localhost:8000
# localhost:8000/content

#Path do Manga
# chapts/"Nome"/
