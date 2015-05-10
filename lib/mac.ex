defmodule Mac do
  def test_program do
    [
      {:psh, 5},
      {:psh, 6},
      :add,
      :print,
      :hlt
    ]
  end

  def execute(instructions), do: _execute(instructions, [], %{a: 0, b: 0, c: 0, d: 0, e: 0})

  defp _execute([:hlt | _], _stack, _registers), do: IO.puts("HALTED")

  defp _execute([{:psh, val} | tail], stack, registers) do
    stack = Mac.Stack.push(stack, val)

    _execute(tail, stack, registers)
  end

  defp _execute([:add | tail], stack, registers) do
    {stack, val1} = Mac.Stack.pop(stack)
    {stack, val2} = Mac.Stack.pop(stack)
    stack = Mac.Stack.push(stack, val1 + val2)

    _execute(tail, stack, registers)
  end

  defp _execute([:pop | tail], stack, registers) do
    {stack, _val} = Mac.Stack.pop(stack)

    _execute(tail, stack, registers)
  end

  defp _execute([:print | tail], stack, registers) do
    {stack, val} = Mac.Stack.pop(stack)
    IO.puts(val)

    _execute(tail, stack, registers)
  end

  defp _execute([{:set, val, reg} | tail], registers) do
    registers = Mac.Registers.set(registers, register, val)

    _execute(tail, stack, registers)
  end
end
