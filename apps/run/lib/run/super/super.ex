defmodule Run.Super do
  @moduledoc """
  The Super context.
  """

  import Ecto.Query, warn: false
  alias Run.Repo
  alias Run.Accounts.User

  def update_permissions(%User{} = user, attrs) do
    user
    |> User.permission_changeset(attrs)
    |> Repo.update()
  end

  def update_super_permissions(%User{} = user, attrs) do
    user
    |> User.super_permission_changeset(attrs)
    |> Repo.update()
  end

  def list_users do
    Repo.all(from u in User, order_by: u.username)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  alias Run.Super.Configuration

  def next_invoice_nr do
    current_invoice_nr + 1
  end

  def current_invoice_nr do
    invoice_nr_query()
    |> last()
    |> Repo.one()
  end

  defp invoice_nr_query do
    from c in Configuration, select: c.invoice_nr
  end

  defp configuration_query do
    from(c in Configuration)
  end

  def configuration do
    configuration_query()
    |> last()
    |> Repo.one()
  end

  def update_invoice_nr do
    configuration()
    |> Configuration.changeset(%{"invoice_nr" => next_invoice_nr()})
    |> Repo.update()
  end

  def get_and_update_invoice_nr do
    {:ok,
     %Run.Super.Configuration{
       invoice_nr: invoice_nr
     }} = update_invoice_nr()

    invoice_nr
  end
end
