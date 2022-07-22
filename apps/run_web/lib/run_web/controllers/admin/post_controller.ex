defmodule RunWeb.Admin.PostController do
  use RunWeb, :controller

  alias Run.Admin
  alias Run.Admin.Post

  def index(conn, _params) do
    posts = Admin.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, %{"blog_id" => blog_id}) do
    blog = Admin.get_blog!(blog_id)
    changeset = Admin.change_post(%Post{blog_id: blog_id})

    render(
      conn
      |> assign(:breadcrumbs, new_breadcrumbs(conn, blog)),
      "new.html",
      changeset: changeset,
      blog: blog
    )
  end

  def create(conn, %{"blog_id" => blog_id, "post" => post_params}) do
    case Admin.create_post(post_params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.admin_blogs_path(conn, :show, blog_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        blog = Admin.get_blog!(blog_id)

        render(
          conn |> assign(:breadcrumbs, breadcrumbs(conn)),
          "new.html",
          changeset: changeset,
          blog: blog
        )
    end
  end

  def show(conn, %{"id" => id}) do
    post = Admin.get_post!(id)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"blog_id" => blog_id, "id" => id}) do
    post = Admin.get_post!(id)
    blog = Admin.get_blog!(blog_id)
    changeset = Admin.change_post(post)

    render(
      conn |> assign(:breadcrumbs, edit_breadcrumbs(conn, blog, post)),
      "edit.html",
      post: post,
      changeset: changeset,
      blog: blog
    )
  end

  def update(conn, %{"blog_id" => blog_id, "id" => id, "post" => post_params}) do
    post = Admin.get_post!(id)
    blog = Admin.get_blog!(blog_id)

    case Admin.update_post(post, post_params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.admin_blogs_path(conn, :show, blog))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn |> assign(:breadcrumbs, breadcrumbs(conn)),
          "edit.html",
          post: post,
          changeset: changeset,
          blog: blog
        )
    end
  end

  def delete(conn, %{"blog_id" => blog_id, "id" => id}) do
    post = Admin.get_post!(id)
    {:ok, _post} = Admin.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.admin_blogs_path(conn, :show, blog_id))
  end

  defp breadcrumbs(conn) do
    %{
      show: true,
      root: %{title: "home", path: Routes.landing_page_path(conn, :index)},
      links: [%{title: "admin", path: Routes.admin_path(conn, :index)}],
      current_page: gettext("blogs")
    }
  end

  defp new_breadcrumbs(conn, blog) do
    %{
      show: true,
      root: %{title: "home", path: Routes.landing_page_path(conn, :index)},
      links: [
        %{title: "admin", path: Routes.admin_path(conn, :index)},
        %{title: blog.title, path: Routes.admin_blogs_path(conn, :show, blog)}
      ],
      current_page: gettext("new")
    }
  end

  defp edit_breadcrumbs(conn, blog, post) do
    %{
      show: true,
      root: %{title: "home", path: Routes.landing_page_path(conn, :index)},
      links: [
        %{title: "admin", path: Routes.admin_path(conn, :index)},
        %{title: blog.title, path: Routes.admin_blogs_path(conn, :show, blog)}
      ],
      current_page: post.title
    }
  end
end
