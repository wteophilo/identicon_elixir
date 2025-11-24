defmodule Identicon do
  @moduledoc """
    Provides methods for creating a Identicon
  """

  def main (input) do
    input
    |> hash_input
  end

  @doc """
  Generates an MD5 hash for the given input and converts it into a list of bytes.

  ## Examples

      iex> Identicon.hash_input("elixir")
      %Identicon.Image{hex: [116, 181, 101, 134, 90, 25, 44, 200, 105, 60, 83, 13, 72, 235, 56, 58]}

  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image {hex: hex}
  end
end
