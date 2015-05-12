defmodule Mac do
  def test_program do
    [
      {:psh, 5},
      {:psh, 6},
      :add,
      :print,
      {:set, 1, :a},
      {:print_reg, :a},
      {:mov, :a, :c},
      {:print_reg, :b},
      {:print_reg, :a},
      {:print_reg, :c},
      {:if, :a, 1, 4},
      {:set, 2, :a},
      :print,
      :hlt
    ]
  end

  def execute(instructions), do:
    _execute(instructions, [], %{a: 0, b: 0, c: 0, d: 0, e: 0}, instructions)

  defp _execute([:hlt | _], _stack, _registers, _instructions),
    do: IO.puts("HALTED")

  defp _execute([:nop | tail], stack, registers, instructions),
    do: _execute(tail, stack, registers, instructions)


  defp _execute([{:psh, val} | tail], stack, registers, instructions) do
    stack = Mac.Stack.push(stack, val)

    _execute(tail, stack, registers, instructions)
  end

  defp _execute([:add | tail], stack, registers, instructions) do
    {stack, val1} = Mac.Stack.pop(stack)
    {stack, val2} = Mac.Stack.pop(stack)
    stack = Mac.Stack.push(stack, val1 + val2)

    _execute(tail, stack, registers, instructions)
  end

  defp _execute([:mult | tail], stack, registers, instructions) do
    {stack, val1} = Mac.Stack.pop(stack)
    {stack, val2} = Mac.Stack.pop(stack)
    stack = Mac.Stack.push(stack, val1 * val2)

    _execute(tail, stack, registers, instructions)
  end

  defp _execute([:div | tail], stack, registers, instructions) do
    {stack, val1} = Mac.Stack.pop(stack)
    {stack, val2} = Mac.Stack.pop(stack)
    stack = Mac.Stack.push(stack, val1 / val2)

    _execute(tail, stack, registers, instructions)
  end

  defp _execute([:subs | tail], stack, registers, instructions) do
    {stack, val1} = Mac.Stack.pop(stack)
    {stack, val2} = Mac.Stack.pop(stack)
    stack = Mac.Stack.push(stack, val1 - val2)

    _execute(tail, stack, registers, instructions)
  end

  defp _execute([:pop | tail], stack, registers, instructions) do
    {stack, _val} = Mac.Stack.pop(stack)

    _execute(tail, stack, registers, instructions)
  end

  defp _execute([:print | tail], stack, registers, instructions) do
    {stack, val} = Mac.Stack.pop(stack)
    IO.puts(val)

    _execute(tail, stack, registers, instructions)
  end

  defp _execute([{:print_reg, register} | tail], stack, registers, instructions) do
    IO.puts Mac.Registers.get(registers, register)

    _execute(tail, stack, registers, instructions)
  end

  defp _execute([{:set, val, register} | tail], stack, registers, instructions) do
    registers = Mac.Registers.set(registers, register, val)

    _execute(tail, stack, registers, instructions)
  end

  defp _execute([{:gld, register} | tail], stack, registers, instructions) do
    val = Mac.Registers.get(registers, register)
    stack = Mac.Stack.push(stack, val)

    _execute(tail, stack, registers, instructions)
  end

  defp _execute([{:gpt, register} | tail], stack, registers, instructions) do
    val = Mac.Stack.top(stack)
    registers = Mac.Registers.set(registers, register, val)

    _execute(tail, stack, registers, instructions)
  end


  defp _execute([{:if, register, val, goto} | tail], stack, registers, instructions) do
    register_val = Mac.Registers.get(registers, register)

    if register_val == val  do
      new_tail = Enum.slice(instructions, goto, length(instructions) - goto)
      _execute(new_tail, stack, registers, instructions)
    else
      _execute(tail, stack, registers, instructions)
    end
  end

  defp _execute([{:ifn, register, val, goto} | tail], stack, registers, instructions) do
    register_val = Mac.Registers.get(registers, register)

    if register_val != val  do
      new_tail = Enum.slice(instructions, goto, length(instructions) - goto)
      _execute(new_tail, stack, registers, instructions)
    else
      _execute(tail, stack, registers, instructions)
    end
  end

  defp _execute([{:mov, orig_register, dest_register} | tail], stack, registers, instructions) do
    registers = Mac.Registers.move(registers, orig_register, dest_register)

    _execute(tail, stack, registers, instructions)
  end
end

