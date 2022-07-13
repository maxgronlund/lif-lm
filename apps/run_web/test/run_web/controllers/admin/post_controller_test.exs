defmodule RunWeb.PostControllerTest do
  use RunWeb.ConnCase

  import Run.AdminFixtures
  import Run.AccountsFixtures

  alias RunWeb.UserAuth
  alias Run.Accounts

  @create_attrs %{author: "some author", body: "some body", title: "some title"}
  @update_attrs %{
    author: "some updated author",
    body: "some updated body",
    title: "some updated title",
    identifier: "some updated identifier"
  }
  @invalid_attrs %{identifier: nil, author: nil, body: nil, title: nil}

  setup %{conn: conn} do
    user = admin_fixture()

    conn =
      conn
      |> Map.replace!(:secret_key_base, RunWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    user_token = Accounts.generate_user_session_token(user)
    conn = conn |> put_session(:user_token, user_token) |> UserAuth.fetch_current_user([])
    blog = blog_fixture()

    %{user: user, conn: conn, blog: blog}
  end

  # describe "index" do
  #   test "lists all posts", %{conn: conn, blog: blog} do
  #     conn = get(conn, Routes.admin_blogs_post_path(conn, :index, blog))
  #     assert html_response(conn, 200) =~ "Listing Posts"
  #   end
  # end

  describe "new post" do
    test "renders form", %{conn: conn, blog: blog} do
      conn = get(conn, Routes.admin_blogs_post_path(conn, :new, blog))
      assert html_response(conn, 200) =~ "New post"
    end
  end

  describe "create post" do
    test "redirects to show blog when data is valid", %{conn: conn, blog: blog} do
      conn = post(conn, Routes.admin_blogs_post_path(conn, :create, blog), post: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_blogs_path(conn, :show, id)

      # assert html_response(conn, 200) =~ @create_attrs["title"]
    end

    test "renders errors when data is invalid", %{conn: conn, blog: blog} do
      conn = post(conn, Routes.admin_blogs_post_path(conn, :create, blog), post: @invalid_attrs)

      assert html_response(conn, 200) =~
               "Oops, something went wrong! Please check the errors below."
    end
  end

  describe "edit post" do
    test "renders form for editing chosen post", %{conn: conn, blog: blog} do
      post = create_post(blog.id)

      conn = get(conn, Routes.admin_blogs_post_path(conn, :edit, blog, post))
      assert html_response(conn, 200) =~ "Edit post"
    end
  end

  describe "update post" do
    test "redirects when data is valid", %{conn: conn, blog: blog} do
      post = create_post(blog.id)

      conn =
        put(conn, Routes.admin_blogs_post_path(conn, :update, blog, post), post: @update_attrs)

      assert redirected_to(conn) == Routes.admin_blogs_path(conn, :show, blog)

      conn = get(conn, Routes.admin_blogs_path(conn, :show, blog))
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, blog: blog} do
      post = create_post(blog.id)

      conn =
        put(conn, Routes.admin_blogs_post_path(conn, :update, blog, post), post: @invalid_attrs)

      assert html_response(conn, 200) =~
               "Oops, something went wrong! Please check the errors below."
    end
  end

  describe "delete post" do
    test "deletes chosen post", %{conn: conn, blog: blog} do
      post = create_post(blog.id)
      conn = delete(conn, Routes.admin_blogs_post_path(conn, :delete, blog, post))
      assert redirected_to(conn) == Routes.admin_blogs_path(conn, :show, blog)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_blogs_post_path(conn, :show, blog, post))
      end
    end
  end

  defp create_post(blog_id) do
    post_fixture(%{blog_id: blog_id})
  end
end
