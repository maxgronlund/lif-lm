defmodule RunWeb.LandingPageControllerTest do
  use RunWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert conn.status == 200
  end
end
