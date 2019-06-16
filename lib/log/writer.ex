defmodule Log.Writer do
  @moduledoc """
  This module is used to write releases and logs. Releases are numbered in the common release date format. *Examples*: `"v1.0.3"` or `"v2.4.3"`.
   All release notes should be preceded by a lowercase "v". This module's functions typically return single atom:  `:ok` or `:error`

  ### Release are made of:
    - Release version -> v1.2.3
    - Release date -> date
    - Release lines -> At least on char long
    - Relased by -> user / organization
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
      release_path()
    else
      {:error, :bad_version}
    end
  end

  @doc """
    Creates a new release with a specified version
  """
  def create(version) do
    IO.inspect(version)
  end

  @doc """
    Creates a new release with a specified version and appends lines to the newly created version
  """
  def create(version, lines) do
    IO.inspect(version)
    IO.inspect(lines)
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
      {"v"} -> {:error, :bad_version}
      {""} -> {:error, :bad_version}
      {"v", major, minor, patch} -> "v#{major}.#{minor}.#{patch}"
      {"v", major, minor} -> "v#{major}.#{minor}.0"
      {"v", major} -> "v#{major}.0.0"
      {major, minor, patch} -> "v#{major}.#{minor}.#{patch}"
      {major, minor} -> "v#{major}.#{minor}.0"
      {major} -> "v#{major}.0.0"
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
