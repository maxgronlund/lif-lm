defmodule Run.AdminTest do
  use Run.DataCase

  alias Run.Admin

  describe "blogs" do
    alias Run.Admin.Blog

    import Run.AdminFixtures

    @invalid_attrs %{description: nil, page: nil, title: nil}

    test "list_blogs/0 returns all blogs" do
      blog = blog_fixture()
      assert Admin.list_blogs() == [blog]
    end

    test "get_blog!/1 returns the blog with given id" do
      blog = blog_fixture()
      assert Admin.get_blog!(blog.id) == blog
    end

    test "create_blog/1 with valid data creates a blog" do
      valid_attrs = %{description: "some description", page: "some page", title: "some title"}

      assert {:ok, %Blog{} = blog} = Admin.create_blog(valid_attrs)
      assert blog.description == "some description"
      assert blog.page == "some page"
      assert blog.title == "some title"
    end

    test "create_blog/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_blog(@invalid_attrs)
    end

    test "update_blog/2 with valid data updates the blog" do
      blog = blog_fixture()

      update_attrs = %{
        description: "some updated description",
        page: "some updated page",
        title: "some updated title"
      }

      assert {:ok, %Blog{} = blog} = Admin.update_blog(blog, update_attrs)
      assert blog.description == "some updated description"
      assert blog.page == "some updated page"
      assert blog.title == "some updated title"
    end

    test "update_blog/2 with invalid data returns error changeset" do
      blog = blog_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_blog(blog, @invalid_attrs)
      assert blog == Admin.get_blog!(blog.id)
    end

    test "delete_blog/1 deletes the blog" do
      blog = blog_fixture()
      assert {:ok, %Blog{}} = Admin.delete_blog(blog)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_blog!(blog.id) end
    end

    test "change_blog/1 returns a blog changeset" do
      blog = blog_fixture()
      assert %Ecto.Changeset{} = Admin.change_blog(blog)
    end
  end

  describe "posts" do
    alias Run.Admin.Post

    import Run.AdminFixtures

    @invalid_attrs %{author: nil, body: nil, title: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Admin.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Admin.get_post!(post.id).id == post.id
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{author: "some author", body: "some body", title: "some title"}

      assert {:ok, %Post{} = post} = Admin.create_post(valid_attrs)
      assert post.author == "some author"
      assert post.body == "some body"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()

      update_attrs = %{
        author: "some updated author",
        body: "some updated body",
        title: "some updated title"
      }

      assert {:ok, %Post{} = post} = Admin.update_post(post, update_attrs)
      assert post.author == "some updated author"
      assert post.body == "some updated body"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_post(post, @invalid_attrs)
      assert post.id == Admin.get_post!(post.id).id
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Admin.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Admin.change_post(post)
    end
  end
end
