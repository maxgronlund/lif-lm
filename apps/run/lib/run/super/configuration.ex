defmodule Run.Super.Configuration do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "configurations" do
    field :invoice_nr, :integer

    timestamps()
  end

  @doc false
  def changeset(configuration, attrs) do
    configuration
    |> cast(attrs, [:invoice_nr])
    |> validate_required([:invoice_nr])
  end
end
