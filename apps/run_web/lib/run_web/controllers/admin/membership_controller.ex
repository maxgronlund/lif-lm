defmodule RunWeb.Admin.MembershipController do
  use RunWeb, :controller

  alias Run.Club
  alias Run.Club.Membership

  # def index(conn, _params) do
  #   memberships = Club.list_memberships()
  #   render(conn, "index.html", memberships: memberships)
  # end

  def new(conn, %{"users_id" => user_id}) do
    user = Club.get_user!(user_id)
    changeset = Club.change_membership(%Membership{})
    start_date = Timex.shift(Timex.today(), days: -1)

    render(
      conn |> assign(:breadcrumbs, breadcrumbs(conn, user, :new)),
      "new.html",
      changeset: changeset,
      user: user,
      start_date: start_date,
      end_date: Timex.shift(start_date, years: 1)
    )
  end

  def create(conn, %{
        "membership" => membership_params,
        "users_id" => user_id
      }) do
    user = Club.get_user!(user_id)

    membership_params =
      Enum.into(
        membership_params,
        %{
          "type" => "membership",
          "amount" => 500,
          "currency" => "dkk",
          "user_id" => user.id,
          "state" => "valid"
        }
      )

    case Club.create_membership(membership_params) do
      {:ok, _membership} ->
        conn
        |> put_flash(:info, "membership created successfully.")
        |> redirect(to: Routes.admin_users_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        start_date = Timex.shift(Timex.today(), days: -1)

        render(
          conn |> assign(:breadcrumbs, breadcrumbs(conn, user, :new)),
          "new.html",
          user: user,
          changeset: changeset,
          start_date: start_date,
          end_date: Timex.shift(start_date, years: 1)
        )
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    user = Club.get_user!(user_id)
    membership = Club.get_membership!(id)

    render(
      conn |> assign(:breadcrumbs, breadcrumbs(conn, user, :show)),
      "show.html",
      membership: membership
    )
  end

  def edit(conn, %{"id" => id}) do
    membership = Club.get_membership!(id)
    changeset = Club.change_membership(membership)
    render(conn, "edit.html", membership: membership, changeset: changeset)
  end

  def update(conn, %{"id" => id, "membership" => membership_params}) do
    membership = Club.get_membership!(id)

    case Club.update_membership(membership, membership_params) do
      {:ok, membership} ->
        conn
        |> put_flash(:info, "membership updated successfully.")
        |> redirect(to: Routes.membership_path(conn, :show, membership))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", membership: membership, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    membership = Club.get_membership!(id)
    {:ok, _membership} = Club.delete_membership(membership)
    Run.CheckMemberships.run()

    conn
    |> put_flash(:info, "membership deleted successfully.")
    |> redirect(to: Routes.admin_users_path(conn, :show, membership.user_id))
  end

  defp breadcrumbs(conn, user, :new) do
    %{
      show: true,
      root: %{title: gettext("home"), path: Routes.landing_page_path(conn, :index)},
      links: [
        %{title: gettext("admin"), path: Routes.admin_path(conn, :index)},
        %{title: gettext("users"), path: Routes.admin_users_path(conn, :index)},
        %{title: user.username, path: Routes.admin_users_path(conn, :show, user)}
      ],
      current_page: gettext("New membership")
    }
  end

  defp breadcrumbs(conn, user, :show) do
    %{
      show: true,
      root: %{title: gettext("home"), path: Routes.landing_page_path(conn, :index)},
      links: [
        %{title: gettext("admin"), path: Routes.admin_path(conn, :index)},
        %{title: gettext("users"), path: Routes.admin_users_path(conn, :index)}
      ],
      current_page: user.username
    }
  end
end
