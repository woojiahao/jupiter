defmodule Jupiter.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api

  def handle_event({:READY, _event, _ws_state}) do
    IO.puts("hello world!")
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    msg |> IO.inspect()

    case msg.content do
      "ping!" ->
        Api.create_message(msg.channel_id, "I copy and pasted this code")

      _ ->
        :ignore
    end
  end
end
