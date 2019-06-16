defmodule ExTack.ReleaseTest do
  use ExUnit.Case

  @version "v1.4.3"
  @populated_line_content "Populated Line"
  @new_line_content "Hello World"
  @empty_release %ExTack.Release{}
  @line %ExTack.Line{line_number: 1, line_content: @populated_line_content}
  @non_empty_release %ExTack.Release{version: @version, lines: [@line]}
  @markdown "## Release #{@version}\n- #{@populated_line_content}\n"

  test "append_lines/2 - with empty release" do
    assert Enum.count(@empty_release.lines) == 0
    updated_release = ExTack.Release.append_lines([@new_line_content], @empty_release)
    assert Enum.count(updated_release.lines) > 0

    updated_release.lines
    |> Enum.each(fn line ->
      assert line.line_number == 1
      assert line.line_content == @new_line_content
    end)
  end

  test "append_lines/2 - with non empty release" do
    assert Enum.count(@non_empty_release.lines) > 0
    updated_release = ExTack.Release.append_lines([@new_line_content], @non_empty_release)
    assert Enum.count(updated_release.lines) > 1
  end

  test "to_markdown/1" do
    expected_output = "## Release #{@version}\n- #{@populated_line_content}\n"
    result = ExTack.Release.to_markdown(@non_empty_release)
    assert result == expected_output
  end

  test "from_markdown/1 - with binary markdown" do
    result = ExTack.Release.from_markdown(@markdown)
    assert result.version == @version
    assert Enum.count(result.lines) == 1
    assert List.first(result.lines).line_content == @populated_line_content
  end

  test "from_markdown/1 - with tuple markdown" do
    result = ExTack.Release.from_markdown({:ok, @markdown, "some_filename.md"})
    assert result.version == @version
    assert Enum.count(result.lines) == 1
    assert List.first(result.lines).line_content == @populated_line_content
  end
end
