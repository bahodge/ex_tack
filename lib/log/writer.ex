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
  def append_to(version, lines) do
    IO.inspect(version)
    IO.inspect(lines)
  end

  @doc """
    Creates a new release with an incremented release number
  """
  def create do
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
end
