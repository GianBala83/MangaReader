defmodule Mangareader do
  def main do
    IO.puts "Manga Reader - Version 0.4"
    Socket.servidor(8000)
  end
end
