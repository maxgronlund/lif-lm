defmodule RunWeb.CheckoutControllerTest do
  use RunWeb.ConnCase

  import Run.PaymentGatewayFixtures

  @create_attrs %{amount: 42, currency: "some currency", email: "some email", name: "some name", payment_intent_id: "some payment_intent_id"}
  @update_attrs %{amount: 43, currency: "some updated currency", email: "some updated email", name: "some updated name", payment_intent_id: "some updated payment_intent_id"}
  @invalid_attrs %{amount: nil, currency: nil, email: nil, name: nil, payment_intent_id: nil}

  describe "index" do
    test "lists all checkouts", %{conn: conn} do
      conn = get(conn, Routes.checkout_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Checkouts"
    end
  end

  describe "new checkout" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.checkout_path(conn, :new))
      assert html_response(conn, 200) =~ "New Checkout"
    end
  end

  describe "create checkout" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.checkout_path(conn, :create), checkout: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.checkout_path(conn, :show, id)

      conn = get(conn, Routes.checkout_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Checkout"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.checkout_path(conn, :create), checkout: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Checkout"
    end
  end

  describe "edit checkout" do
    setup [:create_checkout]

    test "renders form for editing chosen checkout", %{conn: conn, checkout: checkout} do
      conn = get(conn, Routes.checkout_path(conn, :edit, checkout))
      assert html_response(conn, 200) =~ "Edit Checkout"
    end
  end

  describe "update checkout" do
    setup [:create_checkout]

    test "redirects when data is valid", %{conn: conn, checkout: checkout} do
      conn = put(conn, Routes.checkout_path(conn, :update, checkout), checkout: @update_attrs)
      assert redirected_to(conn) == Routes.checkout_path(conn, :show, checkout)

      conn = get(conn, Routes.checkout_path(conn, :show, checkout))
      assert html_response(conn, 200) =~ "some updated currency"
    end

    test "renders errors when data is invalid", %{conn: conn, checkout: checkout} do
      conn = put(conn, Routes.checkout_path(conn, :update, checkout), checkout: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Checkout"
    end
  end

  describe "delete checkout" do
    setup [:create_checkout]

    test "deletes chosen checkout", %{conn: conn, checkout: checkout} do
      conn = delete(conn, Routes.checkout_path(conn, :delete, checkout))
      assert redirected_to(conn) == Routes.checkout_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.checkout_path(conn, :show, checkout))
      end
    end
  end

  defp create_checkout(_) do
    checkout = checkout_fixture()
    %{checkout: checkout}
  end
end
