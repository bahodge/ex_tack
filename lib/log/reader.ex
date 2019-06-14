defmodule Log.Reader do
  @moduledoc """
  This module is used to read specific releases created. Releases are numbered in the common release date format. *Examples*: `"v1.0.3"` or `"v2.4.3"`.
   All release notes should be preceded by a lowercase "v". This module's functions typically return a two element tuple `{:ok, release}` or `{:error, :not_found}`
  """

  @doc """
    Search realease documents for the current release.
  """

  def read do
    # File.ls("lib/releases")

    {:ok, files} = File.ls("lib/releases")

    Enum.map(files, fn filename ->
      split_filename = String.split(filename, "_")
    end)
    
  end

  @doc """
    Search realease documents for release notes associated with the particular version number
  """

  def read(version) do
    IO.inspect(version)
  end
end
