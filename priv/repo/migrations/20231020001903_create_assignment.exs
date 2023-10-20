defmodule Jupiter.Repo.Migrations.CreateAssignment do
  use Ecto.Migration

  def change do
    create table(:assignment, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :server_snowflake, :string
      add :invite_link, :string
      add :role_snowflake, :string
    end
  end
end
