defmodule RunWeb.Admin.BlogController do
  use RunWeb, :controller

  alias Run.Admin
  alias Run.Admin.Blog

  def index(conn, _params) do
    blogs = Admin.list_blogs()

    render(
      conn
      |> assign(:breadcrumbs, breadcrumbs(conn)),
      "index.html",
      blogs: blogs
    )
  end

  def new(conn, _params) do
    changeset = Admin.change_blog(%Blog{})
    render(conn, "new.html", changeset: changeset)
  end

  # def create(conn, %{"blog" => blog_params}) do
  #   case Admin.create_blog(blog_params) do
  #     {:ok, blog} ->
  #       conn
  #       |> put_flash(:info, "Blog created successfully.")
  #       |> redirect(to: Routes.admin_blogs_path(conn, :show, blog))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(
  #         conn
  #         |> assign(:breadcrumbs, false),
  #         "new.html",
  #         changeset: changeset
  #       )
  #   end
  # end

  def show(conn, %{"id" => id}) do
    blog = Admin.get_blog_with_posts!(id)
    # render(conn, "show.html", blog: blog)

    render(
      conn
      |> assign(:breadcrumbs, show_blog_breadcrumbs(conn, blog)),
      "show.html",
      blog: blog
    )
  end

  def edit(conn, %{"id" => id}) do
    blog = Admin.get_blog!(id)
    changeset = Admin.change_blog(blog)

    render(
      conn |> assign(:breadcrumbs, edit_blog_breadcrumbs(conn, blog)),
      "edit.html",
      blog: blog,
      changeset: changeset
    )
  end

  def update(conn, %{"id" => id, "blog" => blog_params}) do
    blog = Admin.get_blog!(id)

    case Admin.update_blog(blog, blog_params) do
      {:ok, blog} ->
        conn
        |> assign(:breadcrumbs, edit_blog_breadcrumbs(conn, blog))
        |> put_flash(:info, "Blog updated successfully.")
        |> redirect(to: Routes.admin_blogs_path(conn, :show, blog))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn |> assign(:breadcrumbs, edit_blog_breadcrumbs(conn, blog)), "edit.html",
          blog: blog,
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    blog = Admin.get_blog!(id)
    {:ok, _blog} = Admin.delete_blog(blog)

    conn
    |> put_flash(:info, "Blog deleted successfully.")
    |> redirect(to: Routes.admin_blogs_path(conn, :index))
  end

  defp show_blog_breadcrumbs(conn, blog) do
    %{
      show: true,
      root: %{title: "home", path: Routes.landing_page_path(conn, :index)},
      links: [
        %{title: "admin", path: Routes.admin_dashboard_path(conn, :index)},
        %{title: "blogs", path: Routes.admin_blogs_path(conn, :index)}
      ],
      current_page: blog.title
    }
  end

  defp edit_blog_breadcrumbs(conn, blog) do
    %{
      show: true,
      root: %{title: "home", path: Routes.landing_page_path(conn, :index)},
      links: [
        %{title: gettext("admin"), path: Routes.admin_dashboard_path(conn, :index)},
        %{title: gettext("blogs"), path: Routes.admin_blogs_path(conn, :index)},
        %{title: blog.title, path: Routes.admin_blogs_path(conn, :show, blog)}
      ],
      current_page: gettext("edit")
    }
  end

  defp breadcrumbs(conn) do
    %{
      show: true,
      root: %{title: "home", path: Routes.landing_page_path(conn, :index)},
      links: [%{title: "admin", path: Routes.admin_dashboard_path(conn, :index)}],
      current_page: gettext("blogs")
    }
  end
end
