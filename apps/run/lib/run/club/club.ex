defmodule Run.Club do
  @moduledoc """
  The Club context.
  """

  import Ecto.Query, warn: false
  alias Run.Repo

  alias Run.Club.Membership
  alias Run.Accounts.User

  def get_user!(id), do: Run.Accounts.get_user!(id)

  @doc """
  Returns the list of memberships.

  ## Examples

      iex> list_memberships()
      [%Member{}, ...]

  """
  def list_memberships do
    Repo.all(Membership)
  end

  @doc """
  Gets a single membership.

  Raises `Ecto.NoResultsError` if the Membership does not exist.

  ## Examples

      iex> get_membership!(123)
      %Membership{}

      iex> get_membership!(456)
      ** (Ecto.NoResultsError)

  """
  def get_membership!(id), do: Repo.get!(Membership, id)

  def get_memberships_by_user_id(user_id) do
    memberships_by_user_id(user_id)
    |> order_by([m], desc: m.end_date)
    |> Repo.all()
  end

  def get_latest_membership_by_user_id(user_id) do
    memberships_by_user_id(user_id)
    |> order_by([m], asc: m.end_date)
    |> last()
    |> Repo.one()
  end

  defp memberships_by_user_id(user_id) do
    from m in Membership,
      where: m.user_id == ^user_id and m.state != ^"pending"
  end

  @doc """
  Creates a member.

  ## Examples

      iex> create_membership(%{field: value})
      {:ok, %Member{}}

      iex> create_membership(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_membership(attrs \\ %{}) do
    %Membership{}
    |> Membership.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a member.

  ## Examples

      iex> update_membership(membership, %{field: new_value})
      {:ok, %Membership{}}

      iex> update_member(membership, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_membership(%Membership{} = membership, attrs) do
    membership
    |> Membership.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a member.

  ## Examples

      iex> delete_member(member)
      {:ok, %Member{}}

      iex> delete_member(member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_membership(%Membership{} = membership) do
    Repo.delete(membership)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking membership changes.

  ## Examples

      iex> change_membershi(membership)
      %Ecto.Changeset{data: %Membership{}}

  """
  def change_membership(%Membership{} = membership, attrs \\ %{}) do
    Membership.changeset(membership, attrs)
  end

  def change_member(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs)
  end

  def register_member(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def update_member(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def change_edit_member(%User{} = user, attrs \\ %{}) do
    User.update_changeset(user, attrs)
  end
end
