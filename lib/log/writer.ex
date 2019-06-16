defmodule Log.Writer do
  alias Helpers.{Release, VersionFormatter}

  @moduledoc """
  This module is used to write release files. This module's functions typically return single atom:  `:ok` or a two element tuple `{:error, :bad_version}`
  """

  @doc """
    Appends one or more lines to a release.
  """
  def append_to(version, line_content) do
    {:ok, content, filename} = Log.Reader.read(version)

    release =
      Release.append_lines(
        [line_content],
        Release.from_markdown(content)
      )
      |> Release.to_markdown()

    File.write!(file_path(filename), release)
  end

  @doc """
    Creates a new release with an incremented release number
  """
  def create(version) when is_binary(version) do
    create_release_file(VersionFormatter.format_version(version))
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

  defp release_path do
    "lib/releases/#{Mix.env()}"
  end
end
