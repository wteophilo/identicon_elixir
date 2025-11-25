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
    test "should return a new list chunked and mirrored" do
      input = %Identicon.Image{
        hex: [116, 181, 101, 134, 90, 25, 44, 200 , 100],
        color: {116, 181, 101}
      }

      expected_output = %Identicon.Image{
        hex: [[116, 181, 101, 181, 116], [134, 90, 25, 90, 134], [44, 200, 100, 200, 44]],
        color: {116, 181, 101}
      }

      assert Identicon.build_grid(input) == expected_output.hex
    end
  end
end
