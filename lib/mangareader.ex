defmodule Mangareader do
  def main do
    IO.puts "Manga Reader - Version 0.4"
    Socket.servidor(8000)
  end

  def test do
    #Use essa função para testar o retorno de outras funções...
    IO.puts "Use essa função para testar o retorno de outras funções...\n\n\n"

    #API_Manga.request(13)
    x = Information.get_file_infomation("One_Piece")
    IO.puts x["title"]
    IO.puts x["id"]
    IO.inspect(x["chapts"])
    nil
  end

end
