defmodule Jupiter.Consumer do
  use Nostrum.Consumer

  def handle_event({:READY, _event, _ws_state}) do
    IO.puts("Ready!")
  end

  # Weird quirk where GUILD_CREATE does not trigger so we are using this instead
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
    |> then(fn
      {:ok, args} ->
        arg_map = Map.put(args, :channel_snowflake, msg.channel_id)
        Jupiter.Commands.dispatch(arg_map)

        :ignore

      # TODO: handle errors
      {:error, error} ->
        Jupiter.Commands.NotFoundCommand.handle(%{
          channel_snowflake: msg.channel_id
        })

        :ignore

      nil ->
        :ignore
    end)
  end
end
