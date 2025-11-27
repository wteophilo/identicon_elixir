# Identicon

Identicon is a simple library written in Elixir for generating unique Identicon images (hash-based user icons) from any input string.

This implementation follows the basic Identicon logic: it uses the input's MD5 hash to determine the image color and which 50x50 pixel blocks should be filled in a 5x5 grid (total canvas size of 250x250), leveraging Erlang's image processing capabilities (:egd).

## How It Works: The Pipeline

The core functionality is encapsulated in the Identicon.main/1 function, which orchestrates the entire image generation process through a clean Elixir pipeline:

```elixir
def main(input) do
  input
  |> hash_input         # 1. Generate MD5 hash bytes.
  |> pick_color         # 2. Select RGB color from the first 3 bytes.
  |> build_grid         # 3. Create a 5x5 grid with horizontal mirroring.
  |> filter_odd_squares # 4. Keep only the blocks with an even byte value.
  |> build_pixel_map    # 5. Map the remaining blocks to (x, y) coordinates.
  |> draw_image         # 6. Draw the image using Erlang's :egd library.
  |> save_image(input)  # 7. Save the binary data as a PNG file.
end
```
Aqui está o arquivo README.md completo em inglês, incluindo todas as seções e detalhes de implementação que você havia solicitado.

## Installation & Dependencies
To use this library, you will need a functional installation of Elixir and Erlang/OTP.

Clone the repository (assuming the code is in a Mix project):

```
git clone [YOUR-REPOSITORY]
cd [YOUR-REPOSITORY]
```

Verify Dependencies: This project relies on the standard Erlang application :crypto for hashing and, crucially, the Erlang GD library (:egd) for image rendering. Ensure that :egd is available and configured in your Erlang/OTP environment.

### Fix
Maybe you will have an error on Linux when try to use function draw_image thats happen bacause the egd isn't using crc32 but you can edit deps/egd/src/egd_png.erl and change:
```
Crc = zlib:crc32(Z, Bin),
```
to:

```
Crc = erlang:crc32(Bin),
```

Then recompile:

```elixir
mix deps.compile egd --force
```

##  Usage
Call the Identicon.main/1 function with any string of your choice. The result will be a PNG file generated in the current directory, named after your input string.

Example via IEx (Interactive Elixir)
Start iex in your project directory:

```
iex -S mix
Execute the function:
```

```elixir
# This will create a file named 'hello_world.png'
Identicon.main("hello_world")
```