defmodule Log.Reader do
  @moduledoc """
  This module is used to read specific releases created. This module's functions typically return a tuple `{:ok, release_content, filename}` or `{:error, :not_found}`
  """

  @doc """
    Search realease documents for the current release.
  """
  def read do
    filename = read_releases() |> find_current_release()
    if blank?(filename), do: {:error, :not_found}, else: read_file(filename)
  end

  @doc """
  Search realease documents for release notes associated with the particular version number
  """
  @spec read(binary()) :: {:ok, binary(), binary()} | {:error, :not_found}
  def read(version) do
    filename =
      read_releases()
      |> sort_releases()
      |> find_release_from_version(version)

    if blank?(filename), do: {:error, :not_found}, else: read_file(filename)
  end

  defp read_releases do
    find_or_create_release_directory!()
    File.ls("lib/releases/#{Mix.env()}")
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
    {:ok, contents} =
      Path.join("lib/releases/#{Mix.env()}", filename)
      |> File.read()

    {:ok, contents, filename}
  end

  defp find_or_create_release_directory! do
    {:ok, directories} = File.ls("lib/releases")
    dir = directories |> Enum.find(fn directory -> Mix.env() == directory end)
    if blank?(dir), do: File.mkdir("lib/releases/#{Mix.env()}")
  end

  defp blank?(str) do
    case str do
      nil -> true
      _ -> String.trim(str) == ""
    end
  end
end
