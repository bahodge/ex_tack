defmodule ExTack do
  alias Log.{Writer, Reader}

  @moduledoc """
    This is the entry point for the application. Users can use the following commands in order to manage their releases.
  """

  @doc """
    Initializes the directory structure for the current environment
  """
  def init do
    create_directory_structure!()
  end

  @doc """
    create a new release
  """
  def create(version) do
    Writer.create(version)
  end

  @doc """
    Create a new release with content
  """
  def create(version, content) do
    case Writer.create(version) do
      {:error, :bad_version} -> IO.puts("Could not create the release with version #{version}")
      _ -> Writer.append_to(version, content)
    end
  end

  @doc """
    Appends the content to a specific release after finding or creating it
  """
  def update_or_create(version, content) do
    case Reader.read(version) do
      {:error, :not_found} -> create(version, content)
      {_status, _content, _filename} -> Writer.append_to(version, content)
    end
  end

  @doc """
    Append content to a version
  """
  def append_to(version, content) do
    Writer.append_to(version, content)
  end

  @doc """
    Output a release version to markdown
  """
  def read(version) do
    Reader.read(version)
  end

  @doc """
    Output the most recent release version to markdown
  """
  def read do
    Reader.read
  end

  defp create_directory_structure! do
    {:ok, lib_list} = File.ls("lib/")

    unless Enum.find(lib_list, fn list_item -> list_item == "releases" end),
      do: File.mkdir("lib/releases")

    {:ok, releases_list} = File.ls("lib/releases")

    unless Enum.find(releases_list, fn list_item -> list_item == "releases" end),
      do: File.mkdir("lib/releases/#{Mix.env()}")
  end
end
