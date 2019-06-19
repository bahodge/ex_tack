defmodule ExTack do
  alias Log.{Writer, Reader}
  alias Helpers.VersionFormatter

  # @release_directory Application.get_env(:release_directory)

  @typedoc """
    Versions are the primary way to find releases. All versions should be binaries preceded by a `"v"`
    Examples `"v1.3.4"` || `"v1.3"` || `"v3"`
  """
  @type version() :: String.t()

  @moduledoc """
    This is the entry point for the application. Users can use the following commands in order to manage their releases.
  """

  @doc """
    Initializes the directory structure for the current environment. This command should be executed first inorder to ensure that the
    correct directory structure has been created
  """
  def init do
    create_directory_structure!()
  end

  @doc """
    create a new release with a specified version
  """
  @spec create(version) :: atom() | {:error, :bad_version}
  def create(version) do
    init()

    VersionFormatter.format_version(version)
    |> Writer.create()
  end

  @doc """
    Create a new release with content
  """
  @spec create(version, binary) :: atom() | {:error, :bad_version}
  def create(version, content) do
    formatted_version = VersionFormatter.format_version(version)

    case Writer.create(formatted_version) do
      {:error, :bad_version} ->
        IO.puts("Could not create the release with version #{formatted_version}")

      _ ->
        Writer.append_to(formatted_version, content)
    end
  end

  @doc """
    Appends the content to a specific release after finding or creating it
  """
  @spec update_or_create(version, binary) :: atom() | {:error, :bad_version}
  def update_or_create(version, content) do
    formatted_version = VersionFormatter.format_version(version)

    case Reader.read(formatted_version) do
      {:error, :not_found} -> create(formatted_version, content)
      {_status, _content, _filename} -> Writer.append_to(formatted_version, content)
    end
  end

  @doc """
    Append content to a version
  """
  @spec append_to(version, binary) :: atom() | {:error, :bad_version}
  def append_to(version, content) do
    init()

    VersionFormatter.format_version(version)
    |> Writer.append_to(content)
  end

  @doc """
    Output a release version to markdown
  """
  @spec read(version) :: {:ok, binary, binary} | {:error, :not_found}
  def read(version) do
    VersionFormatter.format_version(version) |> Reader.read()
  end

  @doc """
    Output the most recent release version to markdown
  """
  def read do
    Reader.read()
  end

  defp create_directory_structure! do
    {:ok, lib_list} = File.ls("lib")

    unless Enum.find(lib_list, fn list_item -> list_item == "releases" end),
      do: File.mkdir("lib/releases")

    {:ok, releases_list} = File.ls("lib/releases")

    unless Enum.find(releases_list, fn list_item -> list_item == "releases" end),
      do: File.mkdir("lib/releases/#{Mix.env()}")
  end
end
