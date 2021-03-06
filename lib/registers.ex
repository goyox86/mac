defmodule Mac.Registers do
  def set(registers, register, val) when is_atom(register) do
    Dict.put(registers, register, val)
  end

  def get(registers, register) when is_atom(register) do
    Dict.get(registers, register)
  end

  def move(registers, orig, dest) when is_atom(orig) and is_atom(dest) do
    val = Dict.get(registers, orig)
    registers = set(registers, orig, 0)
    registers = set(registers, dest, val)
  end
end
