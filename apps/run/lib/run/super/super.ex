defmodule Run.Super do
  import Ecto.Query, warn: false

  alias Run.Repo
  alias Run.Accounts.User

  def update_permissions(%User{} = user, attrs) do
    user
    |> User.permission_changeset(attrs)
    |> Repo.update()
  end
end
