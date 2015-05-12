defmodule MacTest do
  use ExUnit.Case

  test "the NOP instruction does not do anything" do
    {stack, registers, instructions} = Mac.eval(:nop, [], %{}, [])

    assert {stack, registers, instructions} ==  { [], %{}, [] }
  end

  test "the PSH instruction inserts a value onto the stack not do anything" do
    {stack, _, _} = Mac.eval({:psh, 1}, [], %{}, [])

    assert stack == [1]
  end

  test "the ADD instruction pops the two top values from the stack, adds them and pushes the result back on the stack" do
    { stack , _ , _ }  =  Mac.eval({:psh, 5}, [], %{}, [])
    { stack , _ , _ }  =  Mac.eval({:psh, 6}, stack, %{}, [])

    { stack, _, _ } = Mac.eval(:add, stack, %{}, [])

    assert stack ==  [11]
  end

  test "the ADD instruction pops the two top values from the stack, multiplies them  and pushes the result back on the stack" do
    { stack, _ , _ }  =  Mac.eval({:psh, 5}, [], %{}, [])
    { stack, _ , _ }  =  Mac.eval({:psh, 6}, stack, %{}, [])

    {stack, _ , _} = Mac.eval(:mul, stack, %{}, [])

    assert stack == [30]
  end

  test "the SUB instruction pops the two top values from the stack, substracs them and pushes the result back on the stack" do
    { stack, _ , _ }  =  Mac.eval({:psh, 5}, [], %{}, [])
    { stack, _ , _ }  =  Mac.eval({:psh, 6}, stack, %{}, [])

    {stack, registers, instructions} = Mac.eval(:sub, stack, %{}, [])

    assert stack == [1]
  end

  test "the SUB instruction pops the two top values from the stack, divides them and pushes the result back on the stack" do
    { stack, _ , _ }  =  Mac.eval({:psh, 10}, [], %{}, [])
    { stack, _ , _ }  =  Mac.eval({:psh, 20}, stack, %{}, [])

    { stack, _ , _} = Mac.eval(:div, stack, %{}, [])

    assert stack == [2]
  end

  test "the POP instruction pops the top value from the stack" do
    {stack, _ , _} = Mac.eval(:pop, [1], %{}, [])

    assert stack ==  []
  end

  test "the SET instruction sets the given register to val" do
    {_, registers , _} = Mac.eval({:set, 1, :a}, [], %{a: 0 , b: 0 , c: 0}, [])

    assert registers == %{a: 1, b: 0 , c: 0}
  end

  test "the GLD instruction loads the value on the register onto the stack" do
    {stack , _ , _} = Mac.eval({:gld, :a}, [], %{a: 1 , b: 0 , c: 0}, [])

    assert stack == [1]
  end

  test "the GPD instruction puts top on the stack onto the given register" do
    {_, registers , _} = Mac.eval({:gpt, :a}, [1, 2], %{a: 0 , b: 0 , c: 0}, [])

    assert registers ==  %{a: 1 , b: 0 , c: 0}
  end
end
