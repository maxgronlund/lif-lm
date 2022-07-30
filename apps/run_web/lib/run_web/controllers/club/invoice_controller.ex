defmodule RunWeb.Club.InvoiceController do
  use RunWeb, :controller
  alias Run.Club

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    # user = conn.assigns[:current_user]
    membership = Club.get_membership_with_user!(id)

    render(
      conn |> assign(:breadcrumbs, breadcrumbs(conn)),
      "show.html",
      membership: membership,
      user: membership.user
    )
  end

  defp breadcrumbs(conn) do
    %{
      show: false
    }
  end
end
