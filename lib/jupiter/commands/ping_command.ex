defmodule Jupiter.Commands.PingCommand do
  use Jupiter.Commands.Command

  @impl true
  def handle(%{channel_snowflake: channel_snowflake}) do
    pong_embed =
      %Embed{}
      |> Embed.put_title("Pong!")
      |> Embed.put_description("Jupiter is up and running!")
      |> Embed.put_color(5_763_719)

    Api.create_message(channel_snowflake, embeds: [pong_embed])
  end
end
