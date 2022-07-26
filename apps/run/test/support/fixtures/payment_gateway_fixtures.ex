defmodule Run.PaymentGatewayFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Run.PaymentGateway` context.
  """

  @doc """
  Generate a checkout.
  """
  def checkout_fixture(attrs \\ %{}) do
    {:ok, checkout} =
      attrs
      |> Enum.into(%{
        amount: 42,
        currency: "some currency",
        email: "some email",
        name: "some name",
        payment_intent_id: "some payment_intent_id"
      })
      |> Run.PaymentGateway.create_checkout()

    checkout
  end
end
