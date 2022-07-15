defmodule Run.Repo.Migrations.AddLinkToBlog do
  use Ecto.Migration

  def change do
    alter table(:blogs) do
      add :link, :string, default: "#"
    end
  end
end
