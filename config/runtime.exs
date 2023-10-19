import Config

env = config_env()

Envar.load(".env")

config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  gateway_intents: [
    :guilds,
    :guild_messages,
    :message_content
  ]
