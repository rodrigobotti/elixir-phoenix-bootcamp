defmodule Identicon do
  alias Identicon.Image

  @image_pixel_size 250
  @image_square_size 50
  @image_square_side_amount 5

  def main(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
    |> build_pixel_map()
    |> draw_image()
    |> save_image(input)
  end

  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list()
    |> (&%Image{hex: &1}).()
  end

  def pick_color(%Image{hex: [r, g, b | _tail]} = image) do
    %Image{image | color: {r, g, b}}
  end

  def build_grid(%Image{hex: hex} = image) do
    hex
    |> Enum.chunk_every(3)
    |> Enum.filter(&is_row?/1)
    |> Enum.map(&mirror_row/1)
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.filter(&is_even_code_row?/1)
    |> (&%Image{image | grid: &1}).()
  end

  def build_pixel_map(%Image{grid: grid} = image) do
    grid
    |> Enum.map(&row_to_points/1)
    |> (&%Image{image | pixel_map: &1}).()
  end

  def draw_image(%Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(@image_pixel_size, @image_pixel_size)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {top, bottom} ->
      :egd.filledRectangle(image, top, bottom, fill)
    end)

    :egd.render(image)
  end

  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end

  defp mirror_row([f, s, t]), do: [f, s, t, s, f]
  defp is_row?(row), do: length(row) == 3
  defp is_even_code_row?({code, _index}), do: rem(code, 2) == 0
  defp row_to_points({_code, index}) do
    horizontal = rem(index, @image_square_side_amount) * @image_square_size
    vertical = div(index, @image_square_side_amount) * @image_square_size
    top_left = {horizontal, vertical}
    botton_right = {horizontal + @image_square_size, vertical + @image_square_size}
    {top_left, botton_right}
  end
end
