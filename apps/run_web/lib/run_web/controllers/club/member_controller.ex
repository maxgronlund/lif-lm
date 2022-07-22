defmodule RunWeb.Club.MemberController do
  use RunWeb, :controller

  alias Run.Accounts.User
  alias RunWeb.UserAuth
  alias Run.Accounts
  alias Run.Club
  alias Run.Admin

  def new(conn, _params) do
    blog = Admin.get_blog_with_posts_by_identifier!("New membership")
    changeset = Club.change_member(default_attrs(), %{})

    render(
      conn |> assign(:breadcrumbs, breadcrumbs(conn)),
      "new.html",
      changeset: changeset,
      blog: blog
    )
  end

  def create(conn, %{"user" => user_params}) do
    case Club.register_member(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, gettext("Account created"))
        |> redirect(to: Routes.user_session_path(conn, :new))

      # |> put_flash(:info, "User created successfully.")
      # |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        blog = Admin.get_blog_with_posts_by_identifier!("New membership")

        render(
          conn |> assign(:breadcrumbs, %{show: false}),
          "new.html",
          changeset: changeset,
          blog: blog
        )
    end
  end

  def show(conn, _params) do
    user = conn.assigns.current_user

    render(
      conn |> assign(:breadcrumbs, breadcrumbs(conn)),
      "show.html",
      user: user
    )
  end

  def edit(conn, _params) do
    user = conn.assigns.current_user
    changeset = Club.change_edit_member(user, %{})

    render(
      conn |> assign(:breadcrumbs, breadcrumbs(conn)),
      "edit.html",
      user: user,
      changeset: changeset
    )
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user

    case Club.update_member(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Account updated successfully.")
        |> redirect(to: Routes.show_member_path(conn, :show))
    end
  end

  defp default_attrs do
    %User{date_of_birth: ~D[1980-06-01], country: "Denmark"}
  end

  defp breadcrumbs(conn) do
    %{
      show: true,
      root: %{title: gettext("Home"), path: Routes.landing_page_path(conn, :index)},
      links: [],
      current_page: gettext("Account")
    }
  end

  defp breadcrumbs(conn) do
    %{
      show: true,
      root: %{title: gettext("Home"), path: Routes.landing_page_path(conn, :index)},
      links: [
        %{title: gettext("Sign up"), path: Routes.sign_up_page_path(conn, :index)}
      ],
      current_page: gettext("New membership")
    }
  end
end
