defmodule Jupiter.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api

  def handle_event({:READY, _event, _ws_state}) do
    IO.puts("Ready!")
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    msg.content
    |> Jupiter.Parser.get_arg_map(msg)
    |> IO.inspect()
  end
end
