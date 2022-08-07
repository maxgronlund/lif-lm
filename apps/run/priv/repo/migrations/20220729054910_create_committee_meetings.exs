defmodule Run.Repo.Migrations.CreateCommitteeMeetings do
  use Ecto.Migration

  def change do
    create table(:committee_meetings, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string)
      add(:summary, :text)
      add(:date, :date)
      add(:time, :time)
      add(:agenda, :text)
      add(:location, :text)
      add(:moderator_id, references(:users, on_delete: :nilify_all, type: :binary_id))
      add(:minutes_taker_id, references(:users, on_delete: :nilify_all, type: :binary_id))
      add(:committee_id, references(:committees, on_delete: :delete_all, type: :binary_id))

      timestamps()
    end

    create(index(:committee_meetings, [:committee_id]))
  end
end
