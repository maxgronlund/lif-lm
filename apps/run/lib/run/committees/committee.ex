defmodule Run.Committee do
  use Ecto.Schema
  import Ecto.Changeset

  alias Run.CommitteeMember
  alias Run.CommitteeMeeting

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "committees" do
    field :description, :string
    field :name, :string
    field :identifier
    # field :enable_meetings, :boolean

    has_many :committee_members, CommitteeMember
    has_many :committee_meetings, CommitteeMeeting

    timestamps()
  end

  @doc false
  def changeset(committee, attrs) do
    committee
    |> cast(
      attrs,
      [
        :name,
        :description,
        :identifier
      ]
    )
    |> validate_required([:name, :description])
    |> validate_length(:name, min: 2, max: 253)
  end
end
