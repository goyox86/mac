defmodule Mac.Stack do
  def push(stack, val), do: [val | stack]

  def pop([]), do: {[], nil}

  def pop(stack) do
    [val | rest] = stack
    {rest, val}
  end

  def top(stack) do
    [val | _rest ] = stack
    {stack, val}
  end
end

