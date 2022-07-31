defmodule RunWeb.Page.LandingController do
  use RunWeb, :controller
  alias Run.Admin

  def index(conn, _params) do
    blog = Admin.get_blog_with_posts_by_identifier!("landing_page")
    about = Admin.get_posts_by_page_id_and_identifier(blog.id, "about")
    sign_up = Admin.get_posts_by_page_id_and_identifier(blog.id, "sign_up")
    training = Admin.get_posts_by_page_id_and_identifier(blog.id, "training")
    contact = Admin.get_posts_by_page_id_and_identifier(blog.id, "contact")
    calendar = Admin.get_posts_by_page_id_and_identifier(blog.id, "calendar")
    events = Admin.get_posts_by_page_id_and_identifier(blog.id, "events")
    committees = Admin.get_posts_by_page_id_and_identifier(blog.id, "committees")

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
