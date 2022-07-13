defmodule Run.AdminFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Run.Admin` context.
  """

  @doc """
  Generate a blog.
  """
  def blog_fixture(attrs \\ %{}) do
    {:ok, blog} =
      attrs
      |> Enum.into(%{
        description: "some description-#{System.unique_integer()}",
        page: "some identifier-#{System.unique_integer()}",
        title: "some title-#{System.unique_integer()}"
      })
      |> Run.Admin.create_blog()

    blog
  end

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        author: "some author-#{System.unique_integer()}",
        body: "some body-#{System.unique_integer()}",
        title: "some title-#{System.unique_integer()}",
        identifier: "some identifier-#{System.unique_integer()}"
      })
      |> Run.Admin.create_post()

    post
  end
end
