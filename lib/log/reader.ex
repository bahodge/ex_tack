defmodule Log.Reader do
  @moduledoc """
  This module is used to read specific releases created. Releases are numbered in the common release date format. *Examples*: `"v1.0.3"` or `"v2.4.3"`.
   All release notes should be preceded by a lowercase "v". This module's functions typically return a two element tuple `{:ok, release}` or `{:error, :not_found}`
  """

  @doc """
    Search realease documents for the current release.
  """

  def read do
    {:ok, file_string} = read_current_release_file()

    file_string
    |> format_file_string
  end

  @doc """
    Search realease documents for release notes associated with the particular version number
  """

  def read(version) do
    IO.inspect(version)
  end

  defp read_current_release_file do
    Path.join("lib/releases", current_release()) |> File.read()
  end

  # defp read_file(filename) do
  #   Path.join("lib/releases", filename) |> File.read()
  # end

  defp format_file_string(file_string) do
    file_string
    |> String.split("\n")
    |> Enum.reject(fn str -> blank?(str) end)
  end

  defp blank?(str) do
    case str do
      nil -> true
      _ -> String.trim(str) == ""
    end
  end

  defp sorted_releases do
    {:ok, releases} = File.ls("lib/releases")

    releases
    |> Enum.sort(fn f1, f2 -> f1 >= f2 end)
  end

  defp current_release do
    sorted_releases()
    |> List.first()
  end

  defp find_by_release_version(version) do
    sorted_releases()
  
  end
end
