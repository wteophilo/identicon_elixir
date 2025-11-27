defmodule Identicon do
  @moduledoc """
    Provides methods for creating a Identicon
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
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

  @doc """
   Filter only odds values from a tupple

   ## Examples
    iex> grid = %Identicon.Image{grid: [{100, 0}, {101, 1}, {102, 2}, {103, 3}]}
    iex> Identicon.filter_odd_squares(grid)
    %Identicon.Image{grid: [{100, 0}, {102, 2}]}

  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Maps a numerical index to a set of pixel coordinates within a 5x5 grid
    of 50x50 pixel blocks (a 250x250 canvas).

    This function converts the sequential index of a block into the
    top-left and bottom-right coordinate pair required for drawing the
    50x50 square.

    ## Parameters
      * `index` (`integer()`): The sequential index of the block (0 to 24).

    ## Returns
      * `{{start_x, start_y}, {stop_x, stop_y}}`: A tuple containing the
        top-left and bottom-right coordinates of the 50x50 block.
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map }
  end

  @doc """
    Draws the Identicon image based on the provided `pixel_map` and renders it as PNG data.

    The function uses the Erlang `:egd` library to create a 250x250 canvas.
    It fills the rectangles defined in the `pixel_map` with the specified color.

    ## Parameters
      * `%Identicon.Image{color: {r, g, b}, pixel_map: pixel_map}`: An image struct
        containing the color (RGB) and a pixel map (a list of tuples in the
        format `{{start_x, start_y}, {stop_x, stop_y}}`).

    ## Returns
      * `binary()`: The raw PNG image binary data rendered by `:egd`.
  """
  def draw_image(%Identicon.Image{color: {r, g, b}, pixel_map: pixel_map}) do
    image_size = 250

    # Create a new image using Erlang's :egd if available; use apply/3 to avoid compile-time checks
    img = apply(:egd, :create, [image_size, image_size])
    fill = apply(:egd, :color, [{r, g, b}])

    Enum.each(pixel_map, fn {{start_x, start_y}, {stop_x, stop_y}} ->
      # :egd.filledRectangle expects inclusive coordinates, so subtract 1 from stop
      apply(:egd, :filledRectangle, [img, {start_x, start_y}, {stop_x - 1, stop_y - 1}, fill])
    end)

    apply(:egd, :render, [img])
  end
  @doc """
    Saves the rendered image binary data to a PNG file on the filesystem.

    The filename is generated from the provided `input` string by appending the `.png` extension.

    ## Parameters
      * `image` (`binary()`): The binary data of the image (typically the output from `draw_image/1`).
      * `input` (`String.t()`): The base string to be used as the filename.

    ## Returns
      * `:ok` | `{:error, reason}`: The result of the file write operation.
  """
  def save_image(image, input) do
    File.write("#{input}.png", image)
  end
end
