defmodule RunWeb.Admin.DashboardController do
  use RunWeb, :controller

  def index(conn, _params) do
    render(
      conn
      |> assign(:breadcrumbs, breadcrumbs(conn))
      |> assign(:tabs, tabs(conn)),
      "index.html"
    )
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
      %{label: gettext("admin"), link: Routes.admin_path(conn, :index), active: true},
      %{label: gettext("blogs"), link: Routes.admin_blogs_path(conn, :index), active: false},
      %{label: gettext("users"), link: Routes.admin_users_path(conn, :index), active: false},
      %{
        label: gettext("committees"),
        link: Routes.admin_committee_path(conn, :index),
        active: false
      }
    ]
  end
end
