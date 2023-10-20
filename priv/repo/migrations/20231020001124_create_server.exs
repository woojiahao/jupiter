defmodule Jupiter.Repo.Migrations.CreateServer do
  use Ecto.Migration

  def change do
    create table(:server, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :server_snowflake, :string
      add :logging_channel_snowflake, :string
    end
  end
end
