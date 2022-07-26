defmodule Run.Repo.Migrations.CreateMemberships do
  use Ecto.Migration

  def change do
    create table(:memberships, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start, :date
      add :end, :date
      add :amount, :integer
      add :currency, :string, default: "dkk"
      add :type, :string
      add :state, :string
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:memberships, [:user_id])
  end
end
