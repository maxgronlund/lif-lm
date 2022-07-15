defmodule Run.Repo.Migrations.AddArchitectToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :architect, :boolean, default: false
    end
  end
end
