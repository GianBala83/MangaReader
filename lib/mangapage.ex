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
