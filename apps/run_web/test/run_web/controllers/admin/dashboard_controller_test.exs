defmodule RunWeb.Admin.DashboardControllerTest do
  use RunWeb.ConnCase, async: true

  setup :register_and_log_in_user

  describe "index" do
    test "render dashboard", %{conn: conn, user: user} do
      promote_to_admin(user)
      conn = get(conn, Routes.admin_dashboard_path(conn, :index))
      response = html_response(conn, 200)
      assert response =~ "Settings"
    end

    test "redirects if user is not admin", %{conn: conn} do
      conn = get(conn, Routes.admin_dashboard_path(conn, :index))
      assert redirected_to(conn) == "/"
    end
  end

  #  def promote_to_admin(user) do
  #    Run.Super.update_permissions(user, %{admin: true})
  #  end
end
