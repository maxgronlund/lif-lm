defmodule Run.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Run.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Run.PubSub}
      # Start a worker by calling: Run.Worker.start_link(arg)
      # {Run.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Run.Supervisor)
  end
end
