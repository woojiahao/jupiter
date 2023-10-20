defmodule Jupiter.Commands.NotFoundCommand do
  use Jupiter.Commands.Command

  @impl true
  def handle(%{channel_snowflake: channel_snowflake}) do
    not_found_embed =
      %Embed{}
      |> Embed.put_title("Unknown!")
      |> Embed.put_description("Jupiter does not have this command!")
      |> Embed.put_color(15_548_997)
      |> Embed.put_field("Available Commands (`j!`)", """
      - help
      - ping
      - list
      - setlogging
      - register
      - unregister
      - editregister
      """)
      |> Embed.put_footer("Run command with j!", nil)

    Api.create_message(channel_snowflake, embeds: [not_found_embed])
  end
end
