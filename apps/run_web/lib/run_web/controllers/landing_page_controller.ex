defmodule RunWeb.LandingPageController do
  use RunWeb, :controller

  def index(conn, _params) do
    blog = Run.Admin.get_blog_with_posts_by_page!("landing_page")
    welcome_post = Run.Admin.get_posts_by_page_id_and_identifier(blog.id, "welcome")
    training_post = Run.Admin.get_posts_by_page_id_and_identifier(blog.id, "training")
    become_member_post = Run.Admin.get_posts_by_page_id_and_identifier(blog.id, "become-member")

    render(
      conn |> assign(:breadcrumbs, %{show: false}),
      "index.html",
      blog: blog,
      training_post: training_post,
      welcome_post: welcome_post,
      become_member_post: become_member_post
    )
  end
end
