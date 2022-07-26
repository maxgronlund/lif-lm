defmodule RunWeb.Payment.CompletedController do
  use RunWeb, :controller

  alias Run.Club

  def show(conn, %{"id" => membership_id}) do
    membership = Club.get_membership!(membership_id)

    Club.update_membership(
      membership,
      %{state: "payed", end: Timex.shift(membership.start, years: 1)}
    )

    render(conn |> assign(:breadcrumbs, %{show: false}), "show.html")
  end
end
