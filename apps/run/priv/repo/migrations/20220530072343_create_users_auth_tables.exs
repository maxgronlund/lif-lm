defmodule Run.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      add :username, :string, null: false
      add :avatar, :string
      add :admin, :boolean, default: false
      add :super, :boolean, default: false
      add :architect, :boolean, default: false
      add :first_name, :string
      add :last_name, :string
      add :street_and_house_nr, :string
      add :zip_code, :string
      add :city, :string
      add :country, :string, default: "Danmark"
      add :date_of_birth, :date
      add :valid_member, :boolean, default: false
      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:users_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
    create unique_index(:users, [:username])
  end
end
