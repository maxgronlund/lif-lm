defmodule RunWeb.Page.AboutController do
  use RunWeb, :controller
  alias Run.Admin

  def index(conn, _params) do
    blog = Admin.get_blog_with_posts_by_identifier!("about_page")

    render(
      conn |> assign(:breadcrumbs, %{show: false}),
      "index.html",
      blog: blog
    )
  end
end
