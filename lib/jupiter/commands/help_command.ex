defmodule Jupiter.Commands.HelpCommand do
  use Jupiter.Commands.Command

  @impl true
  def handle(%{channel_snowflake: channel_snowflake}) do
    help_embed =
      %Embed{}
      |> Embed.put_title("Jupiter Help")
      |> Embed.put_description("""
      Jupiter helps with assigning joining members roles depending on the invite link they used.

      [] are mandatory fields, () are optional fields.
      """)
      |> Embed.put_color(1_752_220)
      |> then(fn embed ->
        command_details = Jupiter.Commands.get_commands() |> Enum.sort()

        Enum.reduce(command_details, embed, fn {command_name, detail}, acc ->
          desc = Map.get(detail, :description)
          usage = Jupiter.Commands.get_command_usage(command_name)

          Embed.put_field(
            acc,
            "`#{command_name}`",
            """
            **Description:** #{desc}
            **Usage:** `#{usage}`
            """
          )
        end)
      end)
      |> Embed.put_footer("Run command with j!", nil)

    Api.create_message(channel_snowflake, embeds: [help_embed])
  end
end
