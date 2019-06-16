defmodule Helpers.VersionFormatterTest do
  use ExUnit.Case
  alias Helpers.VersionFormatter

  @good_version_1 "v1.2.3"
  @good_version_2 "v1.2"
  @good_version_3 "v1"
  @good_version_4 "1"

  @bad_version "1.2.3.4"

  test "format_version/1" do
    expected_result_1 = "v1.2.3"
    expected_result_2 = "v1.2.0"
    expected_result_3 = "v1.0.0"
    expected_result_4 = "v1.0.0"
    assert VersionFormatter.format_version(@good_version_1) == expected_result_1
    assert VersionFormatter.format_version(@good_version_2) == expected_result_2
    assert VersionFormatter.format_version(@good_version_3) == expected_result_3
    assert VersionFormatter.format_version(@good_version_4) == expected_result_4
    assert {:error, :bad_version} = VersionFormatter.format_version(@bad_version)
  end
end
