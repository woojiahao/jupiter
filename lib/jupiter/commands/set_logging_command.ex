defmodule Jupiter.Commands.SetLoggingCommand do
  use Jupiter.Commands.Command

  @impl true
  def handle(%{
        server_snowflake: server_snowflake,
        channel_snowflake: channel_snowflake
      }) do
    {:ok, _} = Jupiter.Query.Servers.add_logging_channel(server_snowflake, channel_snowflake)

    embed =
      %Embed{}
      |> Embed.put_title("Logging set!")
      |> Embed.put_description("Using <##{channel_snowflake}> to log Jupiter events.")
      |> Embed.put_color(5_763_719)

    Api.create_message(channel_snowflake, embeds: [embed])
  end
end
