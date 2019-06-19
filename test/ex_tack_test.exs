defmodule ExTackTest do
  use ExUnit.Case

  @good_version_1 "v1.23.4"
  @good_version_2 "v7.0.4"
  @new_line_content "Hello World"

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
    filename = "#{@good_version_1}_release.md"
    assert {:error, :enoent} = File.read("lib/releases/test/#{filename}")
    assert :ok = ExTack.create(@good_version_1)
    assert {:ok, _content} = File.read("lib/releases/test/#{filename}")
  end

  test "create/2" do
    filename = "#{@good_version_1}_release.md"
    assert {:error, :enoent} = File.read("lib/releases/test/#{filename}")
    assert :ok = ExTack.create(@good_version_1, @new_line_content)
    assert {:ok, _content} = File.read("lib/releases/test/#{filename}")
  end

  test "read/0" do
    ExTack.create(@good_version_1)

    assert {:ok, _content, filename} = ExTack.read()
    assert filename == "#{@good_version_1}_release.md"
  end

  test "read/1" do
    ExTack.create(@good_version_1)
    ExTack.create(@good_version_2)

    assert {:ok, _content, filename} = ExTack.read(@good_version_1)
    assert filename == "#{@good_version_1}_release.md"
  end

  test "update_or_create/2 -> Creates new file" do
    assert :ok = ExTack.create(@good_version_1)
    assert {:ok, content, _filename} = ExTack.read(@good_version_1)

    assert :ok = ExTack.update_or_create(@good_version_1, @new_line_content)
    {:ok, updated_contents, _filename} = ExTack.read(@good_version_1)
    assert content != updated_contents
  end

  test "update_or_create/2 -> Updates existing file" do
    filename = "#{@good_version_1}_release.md"
    assert {:error, :not_found} = ExTack.read(@good_version_1)
    assert :ok = ExTack.update_or_create(@good_version_1, @new_line_content)
    assert {:ok, _content, new_filename} = ExTack.read(@good_version_1)
    assert new_filename == filename
  end
end
