defmodule Jupiter.Commands.Command do
  defmacro __using__(_opts) do
    quote do
      @callback handle(Jupiter.Parser.ArgMap.t()) :: {:ok, any()} | {:error, atom}
    end
  end
end
