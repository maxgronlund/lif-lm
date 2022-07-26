defmodule Run.Club.Membership do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "memberships" do
    field :end, :date
    field :start, :date
    field :amount, :integer
    field :currency, :string, default: "dkk"
    field :type, :string, default: "membership one year"
    field :state, :string, default: "pending"

    belongs_to :user, Run.Accounts.User

    timestamps()
  end

  @attrs [
    :start,
    :type,
    :amount,
    :currency,
    :user_id
  ]

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, @attrs ++ [:end, :type, :state])
    |> validate_required(@attrs)
  end
end
