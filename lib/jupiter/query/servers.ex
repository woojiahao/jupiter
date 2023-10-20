defmodule Jupiter.Query.Servers do
  def create_server(server_snowflake) do
    server = %Jupiter.Schemas.Server{}
    changeset = Jupiter.Schemas.Server.changeset(server, %{server_snowflake: server_snowflake})
    Jupiter.Repo.insert(changeset)
  end

  def get_server(server_snowflake) do
    Jupiter.Schemas.Server
    |> Jupiter.Repo.get_by(server_snowflake: server_snowflake)
  end

  def add_logging_channel(server_snowflake, logging_channel_snowflake) do
    server_snowflake_str = Nostrum.Snowflake.dump(server_snowflake)
    logging_channel_snowflake_str = Nostrum.Snowflake.dump(logging_channel_snowflake)

    server = get_server(server_snowflake_str)

    if is_nil(server) do
      {:error, :server_not_found}
    else
      changeset =
        Jupiter.Schemas.Server.changeset(server, %{
          logging_channel_snowflake: logging_channel_snowflake_str
        })

      Jupiter.Repo.update(changeset)
    end
  end
end
