defmodule Run.Super do
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
end
