defmodule RunWeb.Payment.CheckoutController do
  use RunWeb, :controller

  alias Run.PaymentGateway
  alias Run.PaymentGateway.Checkout

  plug :breadcrumbs

  def index(conn, _params) do
    checkouts = PaymentGateway.list_checkouts()
    render(conn, "index.html", checkouts: checkouts)
  end

  def new(conn, _params) do
    # {:ok, setup_intent} = Stripe.SetupIntent.create(%{})
    # changeset = PaymentGateway.change_checkout(%Checkout{payment_intent_id: setup_intent.id})

    current_user = conn.assigns[:current_user]

    {:ok, session} =
      Stripe.Session.create(%{
        success_url: "https://77ca-80-208-67-148.eu.ngrok.io/success",
        cancel_url: "https://77ca-80-208-67-148.eu.ngrok.io/cancel",
        customer_email: current_user.email,
        line_items: [
          %{price: "price_1LOQ6IEAauiBXiB4CSQwnkBq", quantity: 1}
        ],
        mode: "payment",
        metadata: %{user_id: current_user.email}
      })

    conn
    |> redirect(external: session.url)

    # changeset = PaymentGateway.change_checkout(%Checkout{})
    # render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"checkout" => checkout_params}) do
    case PaymentGateway.create_checkout(checkout_params) do
      {:ok, checkout} ->
        conn
        |> put_flash(:info, "Checkout created successfully.")
        |> redirect(to: Routes.checkout_path(conn, :show, checkout))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    checkout = PaymentGateway.get_checkout!(id)
    render(conn, "show.html", checkout: checkout)
  end

  def edit(conn, %{"id" => id}) do
    checkout = PaymentGateway.get_checkout!(id)
    changeset = PaymentGateway.change_checkout(checkout)
    render(conn, "edit.html", checkout: checkout, changeset: changeset)
  end

  def update(conn, %{"id" => id, "checkout" => checkout_params}) do
    checkout = PaymentGateway.get_checkout!(id)

    case PaymentGateway.update_checkout(checkout, checkout_params) do
      {:ok, checkout} ->
        conn
        |> put_flash(:info, "Checkout updated successfully.")
        |> redirect(to: Routes.checkout_path(conn, :show, checkout))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", checkout: checkout, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    checkout = PaymentGateway.get_checkout!(id)
    {:ok, _checkout} = PaymentGateway.delete_checkout(checkout)

    conn
    |> put_flash(:info, "Checkout deleted successfully.")
    |> redirect(to: Routes.checkout_path(conn, :index))
  end

  defp breadcrumbs(conn, _opts) do
    conn |> assign(:breadcrumbs, %{show: false})
  end

  defp payent_completed_url do
    RunWeb.Endpoint.url()
  end
end
