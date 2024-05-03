defmodule WorkPage do
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
  @link "<a href='http://localhost:8000/chapts/"

  defp gera_link(_work, []), do: ""
  defp gera_link(work, [{cap, pag} | resto]) do
    @link <> "#{String.replace(work, " ", "_")}/#{cap}$#{pag}'>Capítulo #{cap}</a><br>" <> gera_link(work, resto)
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
