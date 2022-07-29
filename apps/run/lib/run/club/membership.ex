defmodule Run.Club.Membership do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "memberships" do
    field :start_date, :date
    field :end_date, :date
    field :amount, :integer
    field :currency, :string, default: "dkk"
    field :type, :string, default: "membership one year"
    field :state, :string, default: "pending"

    belongs_to :user, Run.Accounts.User

    timestamps()
  end

  @required_attrs [
    :start_date,
    :type,
    :amount,
    :currency,
    :user_id
  ]

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, @required_attrs ++ [:end_date, :type, :state])
    |> validate_required(@required_attrs)
  end

  def expire_changeset(membership) do
    attrs = %{state: "expired"}

    membership
    |> cast(attrs, [:state])
  end
end
