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
      {:gpt, :a},
      {:if, :a, 11, 8},
      {:psh, 3},
      {:psh, 2},
      :add,
      :prt,
      :hlt
    ]
  end

  """
    Runs the given set of instructions.
  """
  def run(instructions), do:
    _run(instructions, [], %{a: 0, b: 0, c: 0, d: 0, e: 0}, instructions)

  defp _run([], stack, registers, instructions), do: nil

  defp _run([:hlt | _], _stack, _registers, _instructions), do: IO.puts("HALTED")

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

  defp _run([head | tail], stack, registers, instructions) do
    {stack, registers, instructions} = eval(head, stack, registers, instructions)

    _run(tail, stack, registers, instructions)
  end

  def eval(:nop, stack, registers, instructions) do
    {stack, registers, instructions}
  end

  def eval({:psh, val}, stack, registers, instructions) do
    stack = Mac.Stack.push(stack, val)

    {stack, registers, instructions}
  end

  def eval(:add , stack, registers, instructions) do
    {stack, val1} = Mac.Stack.pop(stack)
    {stack, val2} = Mac.Stack.pop(stack)
    stack = Mac.Stack.push(stack, val1 + val2)

    {stack, registers, instructions}
  end

  def eval(:mul, stack, registers, instructions) do
    {stack, val1} = Mac.Stack.pop(stack)
    {stack, val2} = Mac.Stack.pop(stack)
    stack = Mac.Stack.push(stack, val1 * val2)

    {stack, registers, instructions}
  end

  def eval(:div, stack, registers, instructions) do
    {stack, val1} = Mac.Stack.pop(stack)
    {stack, val2} = Mac.Stack.pop(stack)
    stack = Mac.Stack.push(stack, val1 / val2)

    {stack, registers, instructions}
  end

  def eval(:sub, stack, registers, instructions) do
    {stack, val1} = Mac.Stack.pop(stack)
    {stack, val2} = Mac.Stack.pop(stack)
    stack = Mac.Stack.push(stack, val1 - val2)

    {stack, registers, instructions}
  end

  def eval(:pop, stack, registers, instructions) do
    {stack, _val} = Mac.Stack.pop(stack)

    {stack, registers, instructions}
  end

  def eval(:prt, stack, registers, instructions) do
    {stack, val} = Mac.Stack.pop(stack)
    IO.puts(val)

    {stack, registers, instructions}
  end

  def eval({:prr, register}, stack, registers, instructions) do
    IO.puts Mac.Registers.get(registers, register)

    {stack, registers, instructions}
  end

  def eval({:set, val, register}, stack, registers, instructions) do
    registers = Mac.Registers.set(registers, register, val)

    {stack, registers, instructions}
  end

  def eval({:gld, register}, stack, registers, instructions) do
    val = Mac.Registers.get(registers, register)
    stack = Mac.Stack.push(stack, val)

    {stack, registers, instructions}
  end

  def eval({:gpt, register}, stack, registers, instructions) do
    val = Mac.Stack.top(stack)
    registers = Mac.Registers.set(registers, register, val)

    {stack, registers, instructions}
  end

  def eval({:mov, orig_register, dest_register}, stack, registers, instructions) do
    registers = Mac.Registers.move(registers, orig_register, dest_register)

    {stack, registers, instructions}
  end
end

