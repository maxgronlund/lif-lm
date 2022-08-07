defmodule AOFF.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:committee_members, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :role, :string
      add :committee_id, references(:committees, on_delete: :delete_all, type: :binary_id)
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:committee_members, [:committee_id])
    create index(:committee_members, [:user_id])
  end
end
