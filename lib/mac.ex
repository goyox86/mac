"""
  MAC is a really simple virtual machine.

  Instruction set:
  op   val   usage               function
  --------------------------------------------------------------------
  HLT        hlt                 halts program
  PSH        psh val             pushes <val> to stack
  POP        pop                 pops value from stack
  PRT        prt                 pops value from stack and prints it
  PRR        prr reg             prints value stored on reg
  ADD        add                 adds top two vals on stack
  MUL        mul                 multiplies top two vals on stack
  DIV        div                 divides top two vals on stack
  SUB        sub                 subtracts top two vals on stack
  MOV        mov reg_a, reg_b    movs the value in reg_a to reg_b
  SET        set reg, val        sets the reg to value
  LOG        log a               prints out a
  IF         if reg val ip       if the register == val branch to the ip
  IFN        ifn reg val ip      if the register != val branch to the ip
  GLD        gld reg             loads a register to the stack
  GPT        gpt reg             pushes top of stack to the given register
  NOP        nop                 nothing

"""
defmodule Mac do
  def test_program do
    [
      {:psh, 5},
      {:psh, 6},
      :add,
      :prt,
      {:set, 1, :a},
      {:prr, :a},
      {:mov, :a, :c},
      {:prr, :b},
      {:prr, :a},
      {:prr, :c},
      {:if, :a, 1, 4},
      {:set, 2, :a},
      :prt,
      :hlt
    ]
  end

  def run(instructions) do
  """
    Runs the given program.
  """
  def run(instructions), do:
    _run(instructions, [], %{a: 0, b: 0, c: 0, d: 0, e: 0}, instructions)

  defp _run([:hlt | _], _stack, _registers, _instructions),
    do: IO.puts("HALTED")

  defp _run([:nop | tail], stack, registers, instructions),
    do: _run(tail, stack, registers, instructions)


  defp _run([{:psh, val} | tail], stack, registers, instructions) do
    stack = Mac.Stack.push(stack, val)

    _run(tail, stack, registers, instructions)
  end

  defp _run([:add | tail], stack, registers, instructions) do
    {stack, val1} = Mac.Stack.pop(stack)
    {stack, val2} = Mac.Stack.pop(stack)
    stack = Mac.Stack.push(stack, val1 + val2)

    _run(tail, stack, registers, instructions)
  end

  defp _run([:mul | tail], stack, registers, instructions) do
    {stack, val1} = Mac.Stack.pop(stack)
    {stack, val2} = Mac.Stack.pop(stack)
    stack = Mac.Stack.push(stack, val1 * val2)

    _run(tail, stack, registers, instructions)
  end

  defp _run([:div | tail], stack, registers, instructions) do
    {stack, val1} = Mac.Stack.pop(stack)
    {stack, val2} = Mac.Stack.pop(stack)
    stack = Mac.Stack.push(stack, val1 / val2)

    _run(tail, stack, registers, instructions)
  end

  defp _run([:sub | tail], stack, registers, instructions) do
    {stack, val1} = Mac.Stack.pop(stack)
    {stack, val2} = Mac.Stack.pop(stack)
    stack = Mac.Stack.push(stack, val1 - val2)

    _run(tail, stack, registers, instructions)
  end

  defp _run([:pop | tail], stack, registers, instructions) do
    {stack, _val} = Mac.Stack.pop(stack)

    _run(tail, stack, registers, instructions)
  end

  defp _run([:prt | tail], stack, registers, instructions) do
    {stack, val} = Mac.Stack.pop(stack)
    IO.puts(val)

    _run(tail, stack, registers, instructions)
  end

  defp _run([{:prr, register} | tail], stack, registers, instructions) do
    IO.puts Mac.Registers.get(registers, register)

    _run(tail, stack, registers, instructions)
  end

  defp _run([{:set, val, register} | tail], stack, registers, instructions) do
    registers = Mac.Registers.set(registers, register, val)

    _run(tail, stack, registers, instructions)
  end

  defp _run([{:gld, register} | tail], stack, registers, instructions) do
    val = Mac.Registers.get(registers, register)
    stack = Mac.Stack.push(stack, val)

    _run(tail, stack, registers, instructions)
  end

  defp _run([{:gpt, register} | tail], stack, registers, instructions) do
    val = Mac.Stack.top(stack)
    registers = Mac.Registers.set(registers, register, val)

    _run(tail, stack, registers, instructions)
  end


  defp _run([{:if, register, val, goto} | tail], stack, registers, instructions) do
    register_val = Mac.Registers.get(registers, register)

    if register_val == val  do
      new_tail = Enum.slice(instructions, goto, length(instructions) - goto)
      _run(new_tail, stack, registers, instructions)
    else
      _run(tail, stack, registers, instructions)
    end
  end

  defp _run([{:ifn, register, val, goto} | tail], stack, registers, instructions) do
    register_val = Mac.Registers.get(registers, register)

    if register_val != val  do
      new_tail = Enum.slice(instructions, goto, length(instructions) - goto)
      _run(new_tail, stack, registers, instructions)
    else
      _run(tail, stack, registers, instructions)
    end
  end

  defp _run([{:mov, orig_register, dest_register} | tail], stack, registers, instructions) do
    registers = Mac.Registers.move(registers, orig_register, dest_register)

    _run(tail, stack, registers, instructions)
  end
end

