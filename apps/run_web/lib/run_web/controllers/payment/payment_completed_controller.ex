defmodule RunWeb.Payment.CompletedController do
  use RunWeb, :controller

  alias Run.Club
  alias Run.Admin
  alias Run.Super

  def show(conn, %{"id" => membership_id}) do
    membership = Club.get_membership!(membership_id)

    start_date = membership.start_date
    end_date = Timex.shift(start_date, years: 1)

    Club.update_membership(
      membership,
      %{
        state: state(start_date),
        end_date: end_date,
        invoice_nr: Super.get_and_update_invoice_nr()
      }
    )

    blog = Admin.get_blog_with_posts_by_identifier!("payment_completed")

    render(
      conn |> assign(:breadcrumbs, %{show: false}),
      "show.html",
      blog: blog
    )
  end

  defp state(start_date) do
    case start_date > today() do
      true -> "future"
      _ -> "valid"
    end
  end

  defp today, do: Timex.now() |> Timex.to_datetime()
end
