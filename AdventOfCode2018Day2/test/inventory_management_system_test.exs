defmodule InventoryManagementSystemTest do
  use ExUnit.Case
  doctest InventoryManagementSystem

  test "greets the world" do
    assert InventoryManagementSystem.hello() == :world
  end
end
