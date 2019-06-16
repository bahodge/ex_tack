defmodule Helpers.VersionFormatter do
  def format_version(version) do
    version
    |> String.split("")
    |> Enum.reject(fn i -> blank?(i) || i == "v" end)
    |> Enum.join("")
    |> String.split(".")
    |> List.to_tuple()
    |> case do
      {major, minor, patch} -> "v#{major}.#{minor}.#{patch}"
      {major, minor} -> "v#{major}.#{minor}.0"
      {major} -> "v#{major}.0.0"
      _ -> {:error, :bad_version}
    end
  end

  defp blank?(str) do
    case str do
      nil -> true
      _ -> String.trim(str) == ""
    end
  end
end
