defmodule Mac.Registers do
  def set(registers, register, val) when is_atom(register) do
    Dict.put(registers, register, val)
  end

  def get(registers, register) when is_atom(register) do
    Dict.get(registers, register)
  end
end
