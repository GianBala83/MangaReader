defmodule Information do

  def get_file_infomation (title) do
    path = "C:/Users/ZenoAoi/Desktop/WorkSpace/Elixir 2/Data/data.json"
    {:ok, bits} = File.read(path)
    {:ok, json_map} = Poison.decode(bits)
    json_map[title]
  end

  def get_title_infomation do
    path = "C:/Users/ZenoAoi/Desktop/WorkSpace/Elixir 2/Data/title.json"
    {:ok, bits} = File.read(path)
    {:ok, json_map} = Poison.decode(bits)
    json_map
  end

end
