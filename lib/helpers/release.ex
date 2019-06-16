defmodule Helpers.Release do

  alias Helpers.Line
  @moduledoc """
    A helper to assist in the parsing and conversion of releases. This should only be accessed via api and is not meant to be directly accessed.
  """

  defstruct version: nil, lines: []

  def to_markdown(release) do
    title_line = "## Release #{release.version}"
    lines = sort_lines(release) |> Enum.map(fn line -> "- #{line.line_content}\n" end)
    Enum.join([title_line, lines], "\n")
  end

  def from_markdown({_status, content, _filename}) do
    content |> from_markdown()
  end

  def from_markdown(content) do
    content_lines = String.split(content, "\n") |> Enum.reject(fn item -> blank?(item) end)
    lines = parse_line_item_contents(tl(content_lines))
    append_lines(lines, %__MODULE__{version: parse_version(hd(content_lines))})
  end

  def append_lines([], release), do: release

  def append_lines([line_item_content | tail], release) do
    new_line_number = get_new_line_number(release)
    new_line = %Line{line_number: new_line_number, line_content: line_item_content}
    new_release = %__MODULE__{version: release.version, lines: [new_line | release.lines]}
    append_lines(tail, new_release)
  end

  defp parse_line_item_contents(line_items) do
    line_items
    |> Enum.map(fn line_item ->
      String.split(line_item, "- ")
      |> Enum.reject(fn item -> blank?(item) end)
      |> List.first()
    end)
  end

  defp parse_version(release_version) do
    release_version
    |> String.split("## Release ")
    |> Enum.reject(fn item -> blank?(item) end)
    |> List.first()
  end

  defp get_new_line_number(release) do
    release
    |> reverse_sort_lines()
    |> List.first()
    |> case do
      nil -> 1
      line -> line.line_number + 1
    end
  end

  defp reverse_sort_lines(release) do
    Enum.sort(release.lines, fn x, y -> x.line_number >= y.line_number end)
  end

  defp sort_lines(release) do
    Enum.sort(release.lines, fn x, y -> x.line_number <= y.line_number end)
  end

  defp blank?(str) do
    case str do
      nil -> true
      _ -> String.trim(str) == ""
    end
  end
end
