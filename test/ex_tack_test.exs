defmodule ExTackTest do
  use ExUnit.Case
  doctest ExTack

  test "greets the world" do
    assert ExTack.hello() == :world
  end
end
