defmodule Jupiter.Schemas.Server do
  use Ecto.Schema

  @primary_key {:id, :uuid, autogenerate: true}

  schema "server" do
    field(:server_snowflake, :string)
    field(:logging_channel_snowflake, :string)
    has_many(:assignments, Jupiter.Schemas.Assignment, foreign_key: :id)
  end

  def changeset(server, params \\ %{}) do
    server
    |> Ecto.Changeset.cast(params, [:server_snowflake, :logging_channel_snowflake])
    |> Ecto.Changeset.validate_required([:server_snowflake])
    |> Ecto.Changeset.unique_constraint(:server_snowflake)
  end
end
