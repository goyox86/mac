defmodule Mac.RegistersTest do
  use ExUnit.Case

  test "sets a register to a given value" do
    assert Mac.Registers.set(%{a: 0, b: 0} , :a, 1) == %{a: 1, b: 0}
  end

  test "gets the value stored in a given register" do
    assert Mac.Registers.get(%{a: 2, b: 0} , :a) == 2
  end

  test "moves the value stored in register a to register b" do
    assert Mac.Registers.move(%{a: 2, b: 0} , :a, :b) == %{a: 0, b: 2}
  end
end
