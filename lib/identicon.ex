defmodule Identicon do
  @moduledoc """
    Provides methods for creating a Identicon
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  @doc """
  Generates an MD5 hash for the given input and converts it into a list of bytes.

  ## Examples

      iex> Identicon.hash_input("elixir")
      %Identicon.Image{
        hex: [116, 181, 101, 134, 90, 25, 44, 200, 105, 60, 83, 13, 72, 235, 56, 58],
        color: nil
      }
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image {hex: hex}
  end

  @doc """
    Based on a list of bytes return just the tree initial values and use it to generate RGB color.

    ## Examples
      iex>Identicon.pick_color(%Identicon.Image{hex: [116, 181, 101, 134, 90, 25, 44, 200], color: nil})
      %Identicon.Image{
        hex: [116, 181, 101, 134, 90, 25, 44, 200],
        color: {116, 181, 101}
      }
  """
  def pick_color(%Identicon.Image {hex:   [r, g, b | _tail]} = hex_list) do
    %Identicon.Image{hex_list | color: {r, g , b}}
  end

  @doc """
    Generate a grid based on a image

    ## Examples
      iex> input = %Identicon.Image{hex: [116, 181, 101, 134, 90, 25, 44, 200 , 105], color: {116, 181, 101}, grid: nil}
      iex> Identicon.build_grid(input)
      %Identicon.Image{ hex: [116, 181, 101, 134, 90, 25, 44, 200 , 105], color: {116, 181, 101}, grid: [{116, 0}, {181, 1}, {101, 2}, {181, 3}, {116, 4}, {134, 5}, {90, 6}, {25, 7}, {90, 8}, {134, 9}, {44, 10}, {200, 11}, {105, 12}, {200, 13}, {44, 14}]}
  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
        |> Enum.chunk_every(3, 3, :discard)
        |> Enum.map(&mirror_row/1)
        |> List.flatten
        |> Enum.with_index
    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Based on a list mirror the two initial values

    ## Examples
      iex>Identicon.mirror_row([116, 181, 101])
      [116, 181, 101, 181, 116]
  """
  def mirror_row(row) do
    [first, second | _tail] = row

    row ++ [second, first]
  end
end
