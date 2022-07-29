defmodule RunWeb.Club.AccountController do
  use RunWeb, :controller

  alias Run.Accounts.User
  alias RunWeb.UserAuth
  alias Run.Accounts
  alias Run.Club
  alias Run.Admin

  def new(conn, _params) do
    blog = Admin.get_blog_with_posts_by_identifier!("New membership")
    changeset = Club.change_member(default_attrs, %{})

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

  def edit(conn, _params) do
    user = conn.assigns.current_user

    render(
      conn
      |> assign(:breadcrumbs, breadcrumbs(conn)),
      "edit.html",
      user: user
    )
  end

  defp default_attrs() do
    %User{date_of_birth: ~D[1980-06-01], country: "Denmark"}
  end

  defp breadcrumbs(conn) do
    %{
      show: true,
      root: %{title: gettext("home"), path: Routes.landing_page_path(conn, :index)},
      links: [
        %{title: gettext("Sign up"), path: Routes.sign_up_page_path(conn, :index)}
      ],
      current_page: gettext("New membership")
    }
  end

  defp tabs(conn) do
    [
      %{label: gettext("admin"), link: Routes.admin_path(conn, :index), active: true},
      %{label: gettext("blogs"), link: Routes.admin_blogs_path(conn, :index), active: false},
      %{label: gettext("users"), link: Routes.admin_users_path(conn, :index), actice: false}
    ]
  end
end
