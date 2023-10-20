defmodule Jupiter.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api

  def handle_event({:READY, _event, _ws_state}) do
    IO.puts("Ready!")
  end

  def handle_event({:GUILD_AVAILABLE, %Nostrum.Struct.Guild{id: guild_snowflake}, _ws_state}) do
    IO.puts("Guild available")

    snowflake = Nostrum.Snowflake.dump(guild_snowflake)
    existing_server = Jupiter.Query.Servers.get_server(snowflake)

    if is_nil(existing_server) do
      Jupiter.Query.Servers.create_server(snowflake)
    end
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    msg.content
    |> Jupiter.Parser.get_arg_map(msg)
    |> IO.inspect()
  end
end
