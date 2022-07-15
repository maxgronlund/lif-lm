defmodule RunWeb.User.RegistrationController do
  use RunWeb, :controller

  alias Run.Accounts
  alias Run.Accounts.User
  alias RunWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})

    render(
      conn |> assign(:breadcrumbs, %{show: false}),
      "new.html",
      changeset: changeset
    )
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(
              conn |> assign(:breadcrumbs, %{show: false}),
              :edit,
              &1
            )
          )

        conn
        # |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn |> assign(:breadcrumbs, %{show: false}),
          "new.html",
          changeset: changeset
        )
    end
  end
end
