defmodule RunWeb.User.AccountController do
  use RunWeb, :controller

  defp breadcrumbs(conn) do
    %{
      show: true,
      root: %{title: "home", path: Routes.landing_page_path(conn, :index)},
      links: [],
      current_page: gettext("account")
    }
  end
end
