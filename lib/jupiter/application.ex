defmodule Jupiter.Application do
  use Application

  def start(_type, _args) do
    children = [
      Jupiter.Consumer,
      Jupiter.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
