defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

  describe "hash_input/1" do
    test "returns a known MD5 hash for a specific input" do
      input = "elixir"
      expected_output = %Identicon.Image{hex: [116, 181, 101, 134, 90, 25, 44, 200, 105, 60, 83, 13, 72, 235, 56, 58]}
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
end
