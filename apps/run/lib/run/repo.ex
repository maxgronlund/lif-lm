defmodule Run.Repo do
  use Ecto.Repo,
    otp_app: :run,
    adapter: Ecto.Adapters.Postgres
end
