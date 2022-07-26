defmodule Run.PaymentGatewayTest do
  use Run.DataCase

  alias Run.PaymentGateway

  describe "checkouts" do
    alias Run.PaymentGateway.Checkout

    import Run.PaymentGatewayFixtures

    @invalid_attrs %{amount: nil, currency: nil, email: nil, name: nil, payment_intent_id: nil}

    test "list_checkouts/0 returns all checkouts" do
      checkout = checkout_fixture()
      assert PaymentGateway.list_checkouts() == [checkout]
    end

    test "get_checkout!/1 returns the checkout with given id" do
      checkout = checkout_fixture()
      assert PaymentGateway.get_checkout!(checkout.id) == checkout
    end

    test "create_checkout/1 with valid data creates a checkout" do
      valid_attrs = %{amount: 42, currency: "some currency", email: "some email", name: "some name", payment_intent_id: "some payment_intent_id"}

      assert {:ok, %Checkout{} = checkout} = PaymentGateway.create_checkout(valid_attrs)
      assert checkout.amount == 42
      assert checkout.currency == "some currency"
      assert checkout.email == "some email"
      assert checkout.name == "some name"
      assert checkout.payment_intent_id == "some payment_intent_id"
    end

    test "create_checkout/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PaymentGateway.create_checkout(@invalid_attrs)
    end

    test "update_checkout/2 with valid data updates the checkout" do
      checkout = checkout_fixture()
      update_attrs = %{amount: 43, currency: "some updated currency", email: "some updated email", name: "some updated name", payment_intent_id: "some updated payment_intent_id"}

      assert {:ok, %Checkout{} = checkout} = PaymentGateway.update_checkout(checkout, update_attrs)
      assert checkout.amount == 43
      assert checkout.currency == "some updated currency"
      assert checkout.email == "some updated email"
      assert checkout.name == "some updated name"
      assert checkout.payment_intent_id == "some updated payment_intent_id"
    end

    test "update_checkout/2 with invalid data returns error changeset" do
      checkout = checkout_fixture()
      assert {:error, %Ecto.Changeset{}} = PaymentGateway.update_checkout(checkout, @invalid_attrs)
      assert checkout == PaymentGateway.get_checkout!(checkout.id)
    end

    test "delete_checkout/1 deletes the checkout" do
      checkout = checkout_fixture()
      assert {:ok, %Checkout{}} = PaymentGateway.delete_checkout(checkout)
      assert_raise Ecto.NoResultsError, fn -> PaymentGateway.get_checkout!(checkout.id) end
    end

    test "change_checkout/1 returns a checkout changeset" do
      checkout = checkout_fixture()
      assert %Ecto.Changeset{} = PaymentGateway.change_checkout(checkout)
    end
  end
end
