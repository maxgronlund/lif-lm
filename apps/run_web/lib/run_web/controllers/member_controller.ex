defmodule RunWeb.MembershipController do
  use RunWeb, :controller

  alias Run.Club
  alias Run.Club.Membership

  def index(conn, _params) do
    members = Club.list_members()
    render(conn, "index.html", members: members)
  end

  def new(conn, _params) do
    changeset = Club.change_member(%Membership{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"member" => membership_params}) do
    case Club.create_member(membership_params) do
      {:ok, membership} ->
        conn
        |> put_flash(:info, "Member created successfully.")
        |> redirect(to: Routes.membership_path(conn, :show, membership))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    membership = Club.get_member!(id)
    render(conn, "show.html", membership: membership)
  end

  def edit(conn, %{"id" => id}) do
    membership = Club.get_membership!(id)
    changeset = Club.change_member(membership)
    render(conn, "edit.html", membership: membership, changeset: changeset)
  end

  def update(conn, %{"id" => id, "member" => membership_params}) do
    membership = Club.get_member!(id)

    case Club.update_member(membership, membership_params) do
      {:ok, membership} ->
        conn
        |> put_flash(:info, "Member updated successfully.")
        |> redirect(to: Routes.membership_path(conn, :show, membership))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", membership: membership, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    membership = Club.get_member!(id)
    {:ok, _membership} = Club.delete_member(membership)

    conn
    |> put_flash(:info, "Member deleted successfully.")
    |> redirect(to: Routes.membership_path(conn, :index))
  end
end
