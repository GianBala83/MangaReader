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
    #chapt = ""
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
