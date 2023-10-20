defmodule Jupiter.Repo do
  use Ecto.Repo,
    otp_app: :jupiter,
    adapter: Ecto.Adapters.Postgres
end
