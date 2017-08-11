defmodule CalendarEspecTest do
  use ExUnit.Case
  doctest CalendarEspec

  test "greets the world" do
    assert CalendarEspec.hello() == :world
  end
end
