defmodule MangaPage do

  def reader_file(path) do
    {:ok, img} = File.read(path)
    imagem_base64 = Base.encode64(img)
    "<div class='image-container'><center><img src='data:image/jpeg;charset=utf-8;base64,#{imagem_base64}'></div>"
  end

  def generate_chapt(path, len) do
    Enum.reduce(1..len, [], fn pgs, acc ->
      pgs_string = Integer.to_string(pgs) |> String.pad_leading(3, "0")
      path_jpg = path <> "#{pgs_string}.jpg"
      path_png = path <> "#{pgs_string}.png"
      path_webp = path <> "#{pgs_string}.webp"

      image_path =
        cond do
          File.exists?(path_jpg) -> path_jpg
          File.exists?(path_png) -> path_png
          File.exists?(path_webp) -> path_webp
          true -> nil
        end

      case image_path do
        nil -> acc
        _ -> acc ++ [reader_file(image_path)]
      end
    end)
  end




  def create_manga_page(path, t) do
    { :ok, len } = Information.count_files_in_directory(path)
    images = generate_chapt(path, len)

    EEx.eval_file("lib/front_end/manga_page.html.eex", [title: t, images: images])
    |> String.split("\r\n")
  end

end
