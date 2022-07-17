defmodule RunWeb.Page.LandingController do
  use RunWeb, :controller

  def index(conn, _params) do
    blog = Run.Admin.get_blog_with_posts_by_identifier!("landing_page")
    about = Run.Admin.get_posts_by_page_id_and_identifier(blog.id, "about")
    sign_up = Run.Admin.get_posts_by_page_id_and_identifier(blog.id, "sign-up")
    training = Run.Admin.get_posts_by_page_id_and_identifier(blog.id, "training")
    contact = Run.Admin.get_posts_by_page_id_and_identifier(blog.id, "contact")
    calendar = Run.Admin.get_posts_by_page_id_and_identifier(blog.id, "calendar")
    events = Run.Admin.get_posts_by_page_id_and_identifier(blog.id, "events")
    committees = Run.Admin.get_posts_by_page_id_and_identifier(blog.id, "committees")

    render(
      conn |> assign(:breadcrumbs, %{show: false}),
      "index.html",
      blog: blog,
      about: about,
      sign_up: sign_up,
      training: training,
      contact: contact,
      calendar: calendar,
      events: events,
      committees: committees
    )
  end
end
