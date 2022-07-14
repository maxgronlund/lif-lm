defmodule RunWeb.Super.DashboardController do
  use RunWeb, :controller

  import Plug.BasicAuth

  plug :basic_auth, Application.compile_env(:run, :basic_auth)

  def index(conn, _params) do
    users = Super.list_users()

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
      current_page: gettext("super")
    }
  end
end
