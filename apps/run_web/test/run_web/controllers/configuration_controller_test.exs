defmodule RunWeb.ConfigurationControllerTest do
  use RunWeb.ConnCase

  import Run.SuperFixtures

  @create_attrs %{invoice_id: 42}
  @update_attrs %{invoice_id: 43}
  @invalid_attrs %{invoice_id: nil}

  describe "index" do
    test "lists all configurations", %{conn: conn} do
      conn = get(conn, Routes.configuration_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Configurations"
    end
  end

  describe "new configuration" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.configuration_path(conn, :new))
      assert html_response(conn, 200) =~ "New Configuration"
    end
  end

  describe "create configuration" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.configuration_path(conn, :create), configuration: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.configuration_path(conn, :show, id)

      conn = get(conn, Routes.configuration_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Configuration"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.configuration_path(conn, :create), configuration: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Configuration"
    end
  end

  describe "edit configuration" do
    setup [:create_configuration]

    test "renders form for editing chosen configuration", %{conn: conn, configuration: configuration} do
      conn = get(conn, Routes.configuration_path(conn, :edit, configuration))
      assert html_response(conn, 200) =~ "Edit Configuration"
    end
  end

  describe "update configuration" do
    setup [:create_configuration]

    test "redirects when data is valid", %{conn: conn, configuration: configuration} do
      conn = put(conn, Routes.configuration_path(conn, :update, configuration), configuration: @update_attrs)
      assert redirected_to(conn) == Routes.configuration_path(conn, :show, configuration)

      conn = get(conn, Routes.configuration_path(conn, :show, configuration))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, configuration: configuration} do
      conn = put(conn, Routes.configuration_path(conn, :update, configuration), configuration: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Configuration"
    end
  end

  describe "delete configuration" do
    setup [:create_configuration]

    test "deletes chosen configuration", %{conn: conn, configuration: configuration} do
      conn = delete(conn, Routes.configuration_path(conn, :delete, configuration))
      assert redirected_to(conn) == Routes.configuration_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.configuration_path(conn, :show, configuration))
      end
    end
  end

  defp create_configuration(_) do
    configuration = configuration_fixture()
    %{configuration: configuration}
  end
end
