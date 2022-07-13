defmodule RunWeb.UserSessionController do
  use RunWeb, :controller

  alias Run.Accounts
  alias RunWeb.UserAuth

  def new(conn, _params) do
    render(conn |> assign(:breadcrumbs, %{show: false}), "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn |> assign(:breadcrumbs, %{show: false}), "new.html",
        error_message: dgettext("errors", "Invalid email or password")
      )
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, gettext("Logged out successfully."))
    |> UserAuth.log_out_user()
  end
end
