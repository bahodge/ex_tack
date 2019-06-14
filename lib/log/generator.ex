defmodule Log.Generator do
  @moduledoc """
  This module is responsible for generating the files. Each file created with be a simple markdown file. Each file will house 1 release. See `Log.Exporter`
  on how to crush all or some of these files into one file
  """

  @doc """
  Generates a file which combines the `generate_time_stamp/0` method and the release version, and the file type.
  """
  def generate_release_file(version, file_type) do
  end

  @doc """
  Generates a unique time stamp. These stamps are used for validation and help with ording the releases
  """
  def generate_time_stamp do
  end
end
