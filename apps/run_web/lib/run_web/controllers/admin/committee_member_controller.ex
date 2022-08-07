defmodule RunWeb.Admin.CommitteeMemberController do
  use RunWeb, :controller

  alias Run.Admin.Committees
  alias Run.CommitteeMember
  # alias Run.Accounts.User

  def new(conn, %{"committee_id" => committee_id}) do
    committee = Committees.get_committee!(committee_id)
    changeset = Committees.change_committee_member(%CommitteeMember{})

    render(
      conn
      |> assign(:breadcrumbs, breadcrumbs(conn))
      |> assign(:tabs, tabs(conn)),
      "new.html",
      changeset: changeset,
      committee: committee,
      users: Committees.list_users()
    )
  end

  def create(conn, %{"committee_member" => member_params}) do
    case Committees.create_member(member_params) do
      {:ok, committee_member} ->
        conn
        |> put_flash(:info, gettext("Committee member created successfully."))
        |> redirect(to: Routes.admin_committee_path(conn, :show, committee_member.committee_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        committee = Committees.get_committee!(member_params["committee_id"])

        render(
          conn
          |> assign(:breadcrumbs, breadcrumbs(conn))
          |> assign(:tabs, tabs(conn)),
          "new.html",
          changeset: changeset,
          committee: committee,
          users: Committees.list_users()
        )
    end
  end

  def edit(conn, %{"id" => id}) do
    committee_member = Committees.get_member!(id)
    changeset = Committees.change_committee_member(committee_member)

    render(
      conn
      |> assign(:breadcrumbs, breadcrumbs(conn))
      |> assign(:tabs, tabs(conn)),
      "edit.html",
      committee: committee_member.committee,
      committee_member: committee_member,
      changeset: changeset,
      users: Committees.list_users()
    )
  end

  def update(conn, %{
        "committee_id" => committee_id,
        "committee_member" => params,
        "id" => id
      }) do
    member = Committees.get_member!(id)

    case Committees.update_member(member, params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, gettext("Member updated successfully."))
        |> redirect(to: Routes.admin_committee_path(conn, :show, member.committee_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn
          |> assign(:breadcrumbs, breadcrumbs(conn))
          |> assign(:tabs, tabs(conn)),
          "edit.html",
          member: member,
          committee: member.committee,
          users: Committees.list_users(),
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    member = Committees.get_member!(id)
    {:ok, _member} = Committees.delete_member(member)

    conn
    |> assign(:breadcrumbs, breadcrumbs(conn))
    |> assign(:tabs, tabs(conn))
    |> put_flash(:info, gettext("Member deleted successfully."))
    |> redirect(to: Routes.admin_committee_path(conn, :show, member.committee_id))
  end

  defp breadcrumbs(conn) do
    %{
      show: true,
      root: %{title: gettext("home"), path: Routes.landing_page_path(conn, :index)},
      links: [],
      current_page: gettext("admin")
    }
  end

  defp tabs(conn) do
    [
      %{label: gettext("admin"), link: Routes.admin_path(conn, :index), active: false},
      %{label: gettext("blogs"), link: Routes.admin_blogs_path(conn, :index), active: false},
      %{label: gettext("users"), link: Routes.admin_users_path(conn, :index), active: false},
      %{
        label: gettext("committees"),
        link: Routes.admin_committee_path(conn, :index),
        active: true
      }
    ]
  end
end
