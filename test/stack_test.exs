defmodule Mac.StackTest do
  use ExUnit.Case

  test "pushes elements on the stack" do
    stack = Mac.Stack.push([1], 2)
    assert stack == [2, 1]
  end

  test "pops elements from the stack and returns a copy of the modified stack" do
    {stack, val} = Mac.Stack.pop([2, 1])
    assert val == 2
    assert stack == [1]
  end

  test "returns the element at the top of the stack and returns a copy of the stack" do
    {stack, val} = Mac.Stack.top([2, 1])
    assert val == 2
    assert stack == [2, 1]
  end
end
