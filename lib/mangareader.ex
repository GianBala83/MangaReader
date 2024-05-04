defmodule Mangareader do
  def main do
    IO.puts "Manga Reader - Version 0.4"
    Socket.servidor(8000)
  end

  def test do
    # Funções de test
    nil
  end

  def test_api_return do
    # Use isso para testar o retorno Api
    x = API_Manga.request(13)
    IO.inspect(x)
  end

end
