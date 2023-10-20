defmodule Jupiter.Schemas.Assignment do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "assignment" do
    field(:server_snowflake, :string)
    field(:invite_link, :string)
    field(:role_snowflake, :string)
    belongs_to(:server, Jupiter.Schemas.Server, references: :id, type: :binary_id)
  end

  def changeset(server, params \\ %{}) do
    server
    |> Ecto.Changeset.cast(params, [:server_snowflake, :invite_link, :role_snowflake])
    |> Ecto.Changeset.validate_required([:server_snowflake, :invite_link, :role_snowflake])
  end
end
