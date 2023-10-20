defmodule Jupiter.Commands.Command do
  @callback handle(%{command: String.t(), args: map(), channel_snowflake: Nostrum.Snowflake.t()}) ::
              {:ok, any()} | {:error, atom}

  defmacro __using__(_opts) do
    quote do
      alias Nostrum.Api
      alias Nostrum.Struct.Embed

      @behaviour Jupiter.Commands.Command
    end
  end
end
