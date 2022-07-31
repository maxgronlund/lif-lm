defmodule RunWeb.Page.SignUpController do
  use RunWeb, :controller
  alias Run.Admin
  alias Run.Members
  alias Run.Accounts.User

  def index(conn, _params) do
    blog = Admin.get_blog_with_posts_by_identifier!("sign_up_page")
    grant_races = Admin.get_posts_by_page_id_and_identifier(blog.id, "grant_races")
    club_clothes = Admin.get_posts_by_page_id_and_identifier(blog.id, "club_clothes")
    events = Admin.get_posts_by_page_id_and_identifier(blog.id, "events")
    subscription = Admin.get_posts_by_page_id_and_identifier(blog.id, "subscription")

    render(
      conn |> assign(:breadcrumbs, breadcrumbs(conn)),
      "index.html",
      blog: blog,
      grant_races: grant_races,
      club_clothes: club_clothes,
      events: events,
      subscription: subscription
    )
  end

  defp breadcrumbs(conn) do
    %{
      show: true,
      root: %{title: "home", path: Routes.landing_page_path(conn, :index)},
      links: [],
      current_page: gettext("sign-up")
    }
  end
end
