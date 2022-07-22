defmodule RunWeb.Page.CalendarController do
  use RunWeb, :controller

  def index(conn, _params) do
    render(
      conn |> assign(:breadcrumbs, %{show: false}),
      "index.html"
    )
  end
end
