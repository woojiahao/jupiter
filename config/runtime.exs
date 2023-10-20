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

config :jupiter, Jupiter.Repo,
  database: System.get_env("DATABASE_NAME"),
  username: System.get_env("DATABASE_USERNAME"),
  password: System.get_env("DATABASE_PASSWORD"),
  hostname: System.get_env("DATABASE_HOST")
