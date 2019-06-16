defmodule Log.Writer do
  @moduledoc """
  This module is used to write release files. This module's functions typically return single atom:  `:ok` or a two element tuple `{:error, :bad_version}`
  """

  @doc """
    Appends one or more lines to a release.
  """
  def append_to(version, line_content) do
    {:ok, content, filename} = Log.Reader.read(version)

    release =
      ExTack.Release.append_lines(
        [line_content],
        ExTack.Release.from_markdown(content)
      )
      |> ExTack.Release.to_markdown()

    File.write!(file_path(filename), release)
  end

  @doc """
    Creates a new release with an incremented release number
  """
  def create(version) when is_binary(version) do
    fixed_version = version |> format_version

    if valid_version?(fixed_version) do
      create_release_file(fixed_version)
    else
      {:error, :bad_version}
    end
  end

  defp build_filename(version) do
    "#{version}_release.md"
  end

  defp create_release_file(version) do
    initial_content = "## Release #{version}"

    ("#{release_path()}/" <> build_filename(version))
    |> File.write!(initial_content)
  end

  defp file_path(filename) do
    Path.join(release_path(), filename)
  end

  defp format_version(version) do
    version
    |> String.split("")
    |> Enum.reject(fn i -> i == "." || blank?(i) end)
    |> List.to_tuple()
    |> case do
      {"v", major, minor, patch} -> "v#{major}.#{minor}.#{patch}"
      {"v", major, minor} -> "v#{major}.#{minor}.0"
      {"v", major} -> "v#{major}.0.0"
      _ -> {:error, :bad_version}
    end
  end

  defp valid_version?({:error, :bad_version}), do: false

  defp valid_version?(version) do
    version
    |> String.split("")
    |> Enum.reject(fn i -> i == "." || blank?(i) end)
    |> List.to_tuple()
    |> case do
      {"v", _, _, _} -> true
      _ -> false
    end
  end

  defp release_path do
    "lib/releases/#{Mix.env()}"
  end

  defp blank?(str) do
    case str do
      nil -> true
      _ -> String.trim(str) == ""
    end
  end
end
