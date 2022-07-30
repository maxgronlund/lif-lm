defmodule Run.Repo.Migrations.CreateConfigurations do
  use Ecto.Migration

  def change do
    create table(:configurations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :invoice_nr, :integer

      timestamps()
    end
  end
end
