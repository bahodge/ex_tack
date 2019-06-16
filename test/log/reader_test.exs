defmodule Log.ReaderTest do
  use ExUnit.Case
  # doctest ExTack

  @valid_versions ["v1.0.1", "v2.4.3"]
  @invalid_versions ["v1.2.6", "v78.4.3"]

  defp valid_filenames do
    @valid_versions |> Enum.map(fn version -> "#{version}_release.md" end)
  end

  defp build_valid_files do
    valid_filenames()
    |> Enum.each(fn filename ->
      File.touch("lib/releases/#{Mix.env()}/#{filename}")
    end)
  end

  defp seed_valid_files do
    Enum.zip(@valid_versions, valid_filenames())
    |> Enum.each(fn {version_number, filename} ->
      Path.join("lib/releases/#{Mix.env()}", filename)
      |> File.write!("## Release #{version_number}\n\n- First Line\n- Second Line")
    end)
  end

  defp make_release_files do
    File.mkdir!("lib/releases/#{Mix.env()}")
    build_valid_files()
    seed_valid_files()

    :ok
  end

  defp cleanup_release_files do
    File.rm_rf("lib/releases/#{Mix.env()}")
    :ok
  end

  setup do
    make_release_files()

    on_exit("Some note", fn -> cleanup_release_files() end)
    :ok
  end

  test "read" do
    [current_filename | _] = valid_filenames() |> Enum.sort(fn f1, f2 -> f1 >= f2 end)

    assert {:ok, contents, filename} = Log.Reader.read()
    assert contents != nil
    assert contents != ""
    assert filename == current_filename
  end

  test "read/1" do
    @valid_versions
    |> Enum.map(fn version_number ->
      assert {:ok, _, filename} = Log.Reader.read(version_number)
      assert [version_number | _] = filename |> String.split("_")
    end)

    @invalid_versions
    |> Enum.map(fn version_number ->
      assert {:error, :not_found} = Log.Reader.read(version_number)
    end)
  end
end
