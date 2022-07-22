defmodule Run.Club.Membership do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "memberships" do
    field :end, :date
    field :start, :date
    field :type, :string
    # field :user_id, :binary_id
    belongs_to :user, Run.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, [:start, :end, :type])
    |> validate_required([:start, :end, :type])
  end
end
