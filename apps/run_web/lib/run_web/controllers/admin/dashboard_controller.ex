defmodule RunWeb.Admin.DashboardController do
  use RunWeb, :controller

  def index(conn, _params) do
    render(
      conn
      |> assign(:breadcrumbs, breadcrumbs(conn)),
      "index.html"
    )
  end

  defp breadcrumbs(conn) do
    %{
      show: true,
      root: %{title: "home", path: Routes.landing_page_path(conn, :index)},
      links: [],
      current_page: gettext("admin")
    }
  end
end
