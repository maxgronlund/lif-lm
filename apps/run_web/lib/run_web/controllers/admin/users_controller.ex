defmodule RunWeb.Admin.UsersController do
  use RunWeb, :controller

  alias Run.Admin

  def index(conn, _params) do
    users = Admin.list_users()

    render(
      conn
      |> assign(:breadcrumbs, breadcrumbs(conn))
      |> assign(:tabs, tabs(conn)),
      "index.html",
      users: users
    )
  end

  def show(conn, %{"id" => user_id}) do
    user = Admin.get_user!(user_id)

    render(
      conn
      |> assign(:breadcrumbs, breadcrumbs(conn, user))
      |> assign(:tabs, tabs(conn)),
      "show.html",
      user: user
    )
  end

  def delete(conn, %{"id" => id}) do
    user = Admin.get_user!(id)
    {:ok, _user} = Admin.delete_user(user)

    conn
    |> put_flash(:info, gettext("User deleted"))
    |> redirect(to: Routes.admin_users_path(conn, :index))
  end

  defp breadcrumbs(conn) do
    %{
      show: true,
      root: %{title: "home", path: Routes.landing_page_path(conn, :index)},
      links: [%{title: gettext("admin"), path: Routes.admin_path(conn, :index)}],
      current_page: gettext("users")
    }
  end

  defp breadcrumbs(conn, user) do
    %{
      show: true,
      root: %{title: "home", path: Routes.landing_page_path(conn, :index)},
      links: [
        %{title: gettext("admin"), path: Routes.admin_path(conn, :index)},
        %{title: gettext("users"), path: Routes.admin_users_path(conn, :index)}
      ],
      current_page: user.username
    }
  end

  defp tabs(conn) do
    [
      %{label: gettext("admin"), link: Routes.admin_path(conn, :index), active: false},
      %{label: gettext("blogs"), link: Routes.admin_blogs_path(conn, :index), active: false},
      %{label: gettext("users"), link: Routes.admin_users_path(conn, :index), active: true}
    ]
  end
end
