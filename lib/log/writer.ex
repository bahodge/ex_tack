defmodule Log.Writer do
  @moduledoc """
  This module is used to write releases and logs. Releases are numbered in the common release date format. *Examples*: `"v1.0.3"` or `"v2.4.3"`.
   All release notes should be preceded by a lowercase "v". This module's functions typically return single atom:  `:ok` or `:error`
  """

  # a release should consist of:

  # release version -> v1.2.3
  # release date -> # date
  # release lines -> At least on char long
  # relased by -> # user / organization

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
