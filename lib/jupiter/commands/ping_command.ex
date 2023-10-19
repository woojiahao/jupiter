defmodule Jupiter.Commands.PingCommand do
  use Jupiter.Commands.Command

  @impl
  def handle(message) do
    message |> IO.inspect()
  end
end
