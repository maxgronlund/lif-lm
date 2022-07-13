defmodule RunWeb.Admin.DashboardControllerTest do
  use RunWeb.ConnCase

  import Run.AccountsFixtures

  alias RunWeb.UserAuth
  alias Run.Accounts

  setup %{conn: conn} do
    user = user_fixture()

    conn =
      conn
      |> Map.replace!(:secret_key_base, RunWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    user_token = Accounts.generate_user_session_token(user)
    conn = conn |> put_session(:user_token, user_token) |> UserAuth.fetch_current_user([])

    %{user: user, conn: conn}
  end

  describe "index" do
    test "show the dashboard", %{conn: conn} do
      conn = get(conn, Routes.admin_dashboard_path(conn, :index))
      assert html_response(conn, 200) =~ "Admin"
    end
  end
end
