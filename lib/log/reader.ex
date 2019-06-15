defmodule Log.Reader do
  @moduledoc """
  This module is used to read specific releases created. Releases are numbered in the common release date format. *Examples*: `"v1.0.3"` or `"v2.4.3"`.
   All release notes should be preceded by a lowercase "v". This module's functions typically return a two element tuple `{:ok, release}` or `{:error, :not_found}`
  """

  @doc """
    Search realease documents for the current release.
  """

  def read do
    filename = read_releases |> find_current_release()
    if blank?(filename), do: {:error, :not_found}, else: read_file(filename)
  end

  @doc """
  Search realease documents for release notes associated with the particular version number
  """

  def read(version) do
    filename =
      read_releases()
      |> sort_releases()
      |> find_release_from_version(version)

    if blank?(filename), do: {:error, :not_found}, else: read_file(filename)
  end

  defp read_releases do
    File.ls("lib/releases")
  end

  defp sort_releases({:ok, files}) do
    files
    |> Enum.sort(fn f1, f2 -> f1 >= f2 end)
  end

  defp find_current_release(releases) do
    releases
    |> sort_releases()
    |> List.first()
  end

  defp find_release_from_version(releases, version) do
    releases
    |> Enum.map(fn filename -> String.split(filename, "_") end)
    |> Enum.find(fn [version_number, _] -> version_number == version end)
    |> case do
      nil -> ""
      version -> Enum.join(version, "_")
    end
  end

  defp read_file(filename) do
    Path.join("lib/releases", filename) |> File.read()
  end

  defp blank?(str) do
    case str do
      nil -> true
      _ -> String.trim(str) == ""
    end
  end
end
