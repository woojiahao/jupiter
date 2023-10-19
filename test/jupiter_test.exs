defmodule JupiterTest do
  use ExUnit.Case
  doctest Jupiter

  test "greets the world" do
    assert Jupiter.hello() == :world
  end
end
