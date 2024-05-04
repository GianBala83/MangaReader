defmodule Information do

  def get_file_infomation (title) do
    path = "lib/Data/data.json"
    {:ok, bits} = File.read(path)
    {:ok, json_map} = Poison.decode(bits)
    json_map[title]
  end

  def get_title_infomation do
    path = "lib/Data/titles.json"
    {:ok, bits} = File.read(path)
    {:ok, json_map} = Poison.decode(bits)
    json_map
  end

  def get_data_path do
    path = "lib/Data/path.json"
    {:ok, bits} = File.read(path)
    {:ok, json_map} = Poison.decode(bits)
    json_map["path"]
  end


end
