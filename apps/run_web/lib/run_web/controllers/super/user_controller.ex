defmodule RunWeb.Super.UserController do
  use RunWeb, :controller

  import Plug.BasicAuth
  plug :basic_auth, Application.compile_env(:run, :basic_auth)

  def index(conn, _params) do
    users = Run.Super.list_users()

    render(
      conn
      |> assign(:breadcrumbs, breadcrumbs(conn))
      |> assign(:users, users),
      "index.html"
    )
  end

  def edit(conn, %{"id" => id}) do
    user = Run.Super.get_user!(id)
    changeset = Run.Accounts.User.super_permission_changeset(user, %{})

    render(
      conn |> assign(:breadcrumbs, edit_user_breadcrumbs(conn, user)),
      "edit.html",
      user: user,
      changeset: changeset
    )
  end

  def update(conn, %{"id" => id, "user" => params}) do
    user = Run.Super.get_user!(id)

    case Run.Super.update_super_permissions(user, params) do
      {:ok, blog} ->
        conn
        |> assign(:breadcrumbs, breadcrumbs(conn))
        |> put_flash(:info, "User permissions updated.")
        |> redirect(to: Routes.super_users_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn |> assign(:breadcrumbs, edit_user_breadcrumbs(conn, user)), "edit.html",
          user: user,
          changeset: changeset
        )
    end
  end

  defp breadcrumbs(conn) do
    %{
      show: true,
      root: %{title: "home", path: Routes.landing_page_path(conn, :index)},
      links: [%{title: "super", path: Routes.super_dashboard_path(conn, :index)}],
      current_page: gettext("users")
    }
  end

  defp edit_user_breadcrumbs(conn, user) do
    %{
      show: true,
      root: %{title: "home", path: Routes.landing_page_path(conn, :index)},
      links: [%{title: "super", path: Routes.super_dashboard_path(conn, :index)}],
      current_page: user.username
    }
  end
end
