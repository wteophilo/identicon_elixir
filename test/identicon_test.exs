defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

  describe "hash_input/1" do
    test "returns a known MD5 hash for a specific input" do
      input = "elixir"
      expected_output = %Identicon.Image{
        hex: [116, 181, 101, 134, 90, 25, 44, 200, 105, 60, 83, 13, 72, 235, 56, 58],
        color: nil
      }

      assert Identicon.hash_input(input) == expected_output
    end

    test "returns a list of length 16 (MD5 standard)" do
      result = Identicon.hash_input("any random string")
      assert length(result.hex) == 16
    end

    test "produces different hashes for different inputs" do
      hash1 = Identicon.hash_input("foo")
      hash2 = Identicon.hash_input("bar")

      assert hash1 != hash2
    end
  end

  describe "pick_color/1" do
    test "return initial three number of array" do
      input = %Identicon.Image{
        hex: [116, 181, 101, 134, 90, 25, 44, 200],
        color: nil
      }

      expected_output = %Identicon.Image{
        hex: [116, 181, 101, 134, 90, 25, 44, 200],
        color: {116, 181, 101}
      }

      assert Identicon.pick_color(input) == expected_output
    end
  end

  describe "mirror_row/1" do
    test "returns a line with the first two items mirrored" do
      input = [116, 181, 101]
      expected_output = [116, 181, 101, 181, 116]
      assert Identicon.mirror_row(input) == expected_output
    end
  end

  describe "build_grid/1" do
    test "should fill grid data chunked and mirrored" do
      input = %Identicon.Image{
        hex: [116, 181, 101, 134, 90, 25, 44, 200 , 105],
        color: {116, 181, 101},
        grid: nil
      }

      expected_output = %Identicon.Image{
        hex: [116, 181, 101, 134, 90, 25, 44, 200 , 105],
        color: {116, 181, 101},
        grid: [{116, 0}, {181, 1}, {101, 2}, {181, 3}, {116, 4}, {134, 5}, {90, 6}, {25, 7}, {90, 8}, {134, 9}, {44, 10}, {200, 11}, {105, 12}, {200, 13}, {44, 14}]
      }

      identicon = Identicon.build_grid(input)

      assert identicon.grid == expected_output.grid
    end
  end

  describe "filter_odd_squares/1" do
    test "filters tuples whose first element is odd" do
      input_grid = [{100, 0}, {101, 1}, {102, 2}, {103, 3}]

      input_image = %Identicon.Image{
        hex: [],
        color: {0, 0, 0},
        grid: input_grid
      }
      expected_grid = [{100, 0}, {102, 2}]

      expected_image = %Identicon.Image{input_image | grid: expected_grid}

      assert Identicon.filter_odd_squares(input_image) == expected_image
    end
  end
end
