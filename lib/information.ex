defmodule Information do

  def get_file_infomation (title) do
    path = "lib/data/data.json"
    {:ok, bits} = File.read(path)
    {:ok, json_map} = Poison.decode(bits)
    json_map[title]
  end

  def get_title_infomation do
    path = "lib/data/titles.json"
    {:ok, bits} = File.read(path)
    {:ok, json_map} = Poison.decode(bits)
    json_map
  end

  def get_data_path do
    path = "lib/data/path.json"
    {:ok, bits} = File.read(path)
    {:ok, json_map} = Poison.decode(bits)
    json_map["path"]
  end

  def count_files_in_directory(directory) do
    case File.ls(directory) do
      {:ok, files} ->
        {:ok, length(files)}
      {:error, reason} ->
        {:error, reason}
    end
  end


end
