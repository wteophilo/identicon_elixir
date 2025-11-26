defmodule ImageTest do
  use ExUnit.Case
  doctest Identicon.Image

  describe "struct definition" do
    test "has the expected fields with default values" do
      image = %Identicon.Image{}
      assert image.__struct__ == Identicon.Image
      assert image.hex == nil
      assert image.color == nil
      assert image.grid == nil
      assert image.pixel_map == nil
    end

    test "can be initialized with custom values" do
      hex_list = [1, 2, 3]
      rgb_color = {255, 0, 0}
      grid_list = [{1, 1}, {2, 2}, {3, 3}]
      pix_list = [{{10, 0}, {20, 1}, {30, 2}}]

      image = %Identicon.Image{hex: hex_list, color: rgb_color, grid: grid_list, pixel_map: pix_list}

      assert image.hex == hex_list
      assert image.color == rgb_color
      assert image.grid == grid_list
      assert image.pixel_map == pix_list
    end

    test "enforces structure integrity" do
      image = %Identicon.Image{}
      keys = Map.keys(image)

      assert :hex in keys
      assert :color in keys
      assert :grid in keys
      assert :pixel_map in keys
      assert :__struct__ in keys
    end
  end
end
