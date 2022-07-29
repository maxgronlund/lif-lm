defmodule RunWeb.Club.MembershipController do
  use RunWeb, :controller

  alias Run.Club
  alias Run.Club.Membership

  # def index(conn, _params) do
  #   memberships = Club.list_memberships()
  #   render(conn, "index.html", memberships: memberships)
  # end

  def new(conn, _params) do
    current_user = conn.assigns[:current_user]

    latest_membership = Club.get_latest_membership_by_user_id(current_user.id)

    start_date = latest_membership.end_date

    changeset =
      Club.change_membership(%Membership{
        start_date: start_date
      })

    render(
      conn |> assign(:breadcrumbs, breadcrumbs(conn, current_user, :new)),
      "new.html",
      changeset: changeset,
      user: current_user,
      start_date: start_date,
      end_date: Timex.shift(start_date, years: 1)
    )
  end

  defp success_url(membership_id) do
    "#{host_path()}/club/membership/#{membership_id}/success"
  end

  defp error_url(membership_id) do
    "#{host_path()}/club/membership/#{membership_id}/error"
  end

  defp host_path do
    "https://77ca-80-208-67-148.eu.ngrok.io"
  end

  def create(conn, %{
        "membership" => %{"start_date" => start_date}
      }) do
    current_user = conn.assigns[:current_user]

    {:ok, membership} =
      Run.Club.create_membership(%{
        start_date: start_date,
        amount: 500,
        user_id: current_user.id
      })

    {:ok, session} =
      Stripe.Session.create(%{
        success_url: success_url(membership.id),
        cancel_url: error_url(membership.id),
        customer_email: current_user.email,
        line_items: [
          %{price: "price_1LOQ6IEAauiBXiB4CSQwnkBq", quantity: 1}
        ],
        mode: "payment",
        metadata: %{
          user_id: current_user.id,
          membership_id: membership.id
        }
      })

    conn
    |> redirect(external: session.url)

    # membership_params =
    #   Enum.into(
    #     membership_params,
    #     %{
    #       "type" => "membership",
    #       "amount" => 500,
    #       "currency" => "dkk",
    #       "user_id" => user.id
    #     }
    #   )

    # case Club.create_membership(membership_params) do
    #   {:ok, membership} ->
    #     conn
    #     |> put_flash(:info, "membership created successfully.")
    #     |> redirect(to: Routes.show_member_path(conn, :show))

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     start_date = Timex.shift(Timex.today(), days: -1)

    #     render(
    #       conn |> assign(:breadcrumbs, breadcrumbs(conn, user, :new)),
    #       "new.html",
    #       user: user,
    #       changeset: changeset,
    #       start_date: start_date,
    #       end_date: Timex.shift(start_date, years: 1)
    #     )
    # end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    user = Club.get_user!(user_id)
    membership = Club.get_membership!(id)

    render(
      conn |> assign(:breadcrumbs, breadcrumbs(conn, user, :show)),
      "show.html",
      membership: membership
    )
  end

  def edit(conn, %{"id" => id}) do
    membership = Club.get_membership!(id)
    changeset = Club.change_membership(membership)
    render(conn, "edit.html", membership: membership, changeset: changeset)
  end

  def update(conn, %{"id" => id, "membership" => membership_params}) do
    membership = Club.get_membership!(id)

    case Club.update_membership(membership, membership_params) do
      {:ok, membership} ->
        conn
        |> put_flash(:info, "membership updated successfully.")
        |> redirect(to: Routes.membership_path(conn, :show, membership))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", membership: membership, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    membership = Club.get_membership!(id)
    {:ok, _membership} = Club.delete_membership(membership)

    conn
    |> put_flash(:info, "membership deleted successfully.")
    |> redirect(to: Routes.admin_users_path(conn, :show, membership.user_id))
  end

  defp breadcrumbs(conn, _user, :new) do
    %{
      show: true,
      root: %{title: gettext("home"), path: Routes.landing_page_path(conn, :index)},
      links: [
        %{title: gettext("account"), path: Routes.show_member_path(conn, :show)}
      ],
      current_page: gettext("new membership")
    }
  end

  defp breadcrumbs(conn, user, :show) do
    %{
      show: true,
      root: %{title: gettext("home"), path: Routes.landing_page_path(conn, :index)},
      links: [
        %{title: gettext("account"), path: Routes.show_member_path(conn, :show)}
      ],
      current_page: user.username
    }
  end
end
