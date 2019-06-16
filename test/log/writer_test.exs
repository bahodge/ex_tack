defmodule Log.WriterTest do
  use ExUnit.Case

  @major "2"
  @minor "7"
  @patch "9"
  @version "v#{@major}.#{@minor}.#{@patch}"

  @line_content "hello there!"

  defp cleanup_release_files do
    File.rm_rf("lib/releases")
    :ok
  end

  setup do
    ExTack.init()
    on_exit("Some note", fn -> cleanup_release_files() end)
    :ok
  end

  test "create/1" do
    # ensure file doesnt exist
    assert {:error, :not_found} = Log.Reader.read(@version)

    Log.Writer.create(@version)

    result = Log.Reader.read(@version)
    assert elem(result, 0) == :ok
    assert elem(result, 1) == "## Release #{@version}"
    assert elem(result, 2) == "#{@version}_release.md"
  end

  test "append_to/2" do
    Log.Writer.create(@version)
    assert elem(Log.Reader.read(@version), 1) == "## Release #{@version}"

    Log.Writer.append_to(@version, @line_content)
    assert elem(Log.Reader.read(@version), 1) == "## Release #{@version}\n- #{@line_content}\n"
  end
end
