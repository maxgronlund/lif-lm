defmodule RunWeb.BlogControllerTest do
  use RunWeb.ConnCase

  import Run.AdminFixtures
  # import Run.AccountsFixtures

  # alias RunWeb.UserAuth
  # alias Run.Accounts

  @update_attrs %{
    description: "some updated description",
    page: "some updated identifier",
    title: "some updated title"
  }
  @invalid_attrs %{description: nil, page: nil, title: nil}

  setup %{conn: conn} do
    %{conn: conn, user: user} = register_and_log_in_user(%{conn: conn})
    {:ok, user} = promote_to_admin(user)

    %{conn: conn, user: user}
  end

  describe "index" do
    test "lists all blogs", %{conn: conn} do
      conn = get(conn, Routes.admin_blogs_path(conn, :index))
      assert html_response(conn, 200) =~ "Blogs"
    end
  end

  # describe "new blog" do
  #   test "as an architect it renders form", %{conn: conn, user: user} do
  #     conn = get(conn, Routes.admin_blogs_path(conn, :new))
  #     assert html_response(conn, 200) =~ "New Blog"
  #   end
  # end

  # describe "create blog" do
  #   test "redirects to show when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.admin_blogs_path(conn, :create), blog: @create_attrs)

  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == Routes.admin_blogs_path(conn, :show, id)

  #     conn = get(conn, Routes.admin_blogs_path(conn, :show, id))
  #     assert html_response(conn, 200) =~ "Show Blog"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.admin_blogs_path(conn, :create), blog: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "New Blog"
  #   end
  # end

  describe "edit blog" do
    setup [:create_blog]

    test "renders form for editing chosen blog", %{conn: conn, blog: blog} do
      conn = get(conn, Routes.admin_blogs_path(conn, :edit, blog))
      assert html_response(conn, 200) =~ "Edit Blog"
    end
  end

  describe "update blog" do
    setup [:create_blog]

    test "redirects when data is valid", %{conn: conn, blog: blog} do
      conn = put(conn, Routes.admin_blogs_path(conn, :update, blog), blog: @update_attrs)
      assert redirected_to(conn) == Routes.admin_blogs_path(conn, :show, blog)

      conn = get(conn, Routes.admin_blogs_path(conn, :show, blog))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, blog: blog} do
      conn = put(conn, Routes.admin_blogs_path(conn, :update, blog), blog: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Blog"
    end
  end

  # describe "delete blog" do
  #   setup [:create_blog]

  #   test "deletes chosen blog", %{conn: conn, blog: blog} do
  #     conn = delete(conn, Routes.admin_blogs_path(conn, :delete, blog))
  #     assert redirected_to(conn) == Routes.admin_blogs_path(conn, :index)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.admin_blogs_path(conn, :show, blog))
  #     end
  #   end
  # end

  defp create_blog(_) do
    blog = blog_fixture()
    %{blog: blog}
  end
end
