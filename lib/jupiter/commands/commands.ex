defmodule Jupiter.Commands do
  # TODO: Allow disabling of logging
  @commands %{
    "help" => %{
      description: "Displays help text containing list of available commands."
    },
    "ping" => %{
      description: "Pings Jupiter to check if it's alive."
    },
    "register" => %{
      description: "Registers a given invite link with a role to assign.",
      components: [
        {:url, "invite_link"},
        {:role, "role"}
      ]
    },
    "unregister" => %{
      description: "Unregisters a given invite link from assigning roles.",
      components: [{:url, "invite_link"}]
    },
    "editregister" => %{
      description: "Edits registered invite link to use different role.",
      components: [{:url, "invite_link"}, {:role, "role"}]
    },
    "setlogging" => %{
      description:
        "Sets the channel that the command is being run to be the logging channel for the server. Re-assigns previous logging channel if any."
    },
    "list" => %{
      description: "Lists the registered assignments for the current server."
    }
  }
  @command_router %{
    "ping" => &Jupiter.Commands.PingCommand.handle/1,
    "help" => &Jupiter.Commands.HelpCommand.handle/1,
    "setlogging" => &Jupiter.Commands.SetLoggingCommand.handle/1
  }

  def dispatch(%{command: command} = arg_map) do
    Map.get(@command_router, command).(arg_map)
  end

  def get_commands, do: @commands

  def get_command_usage(command_name) do
    command = Map.get(@commands, command_name)
    components = Map.get(command, :components, [])

    arguments =
      components
      |> Enum.map(fn
        {type, name} -> "[#{name}]::#{Atom.to_string(type)}"
        {type, name, :optional} -> "[#{name}]::#{Atom.to_string(type)}"
      end)
      |> Enum.join(" ")

    if length(components) == 0,
      do: "j!#{command_name}",
      else: "j!#{command_name} #{arguments}"
  end
end
