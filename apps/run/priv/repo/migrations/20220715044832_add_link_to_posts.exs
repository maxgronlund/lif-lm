defmodule Run.Repo.Migrations.AddLinkToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :link, :string, default: "#"
    end
  end
end
