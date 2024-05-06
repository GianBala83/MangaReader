defmodule Texto do
  def texto_limite(texto) do
    texto
    |> String.split(" ")
    |> separa("", [])
  end

  def separa([], acc, result), do: Enum.reverse([acc | result])
  def separa([palavra | resto], acc, result) do
    if byte_size(acc <> palavra) <= 450 do
      separa(resto, acc <> " " <> palavra, result)
    else
      separa([palavra | resto], "", [acc | result])
    end
  end
end
