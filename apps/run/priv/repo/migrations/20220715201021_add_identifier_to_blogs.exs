defmodule Run.Repo.Migrations.AddIdentifierToBlogs do
  use Ecto.Migration

  def change do
    alter table(:blogs) do
      add :identifier, :string
    end

    unique_index(:blogs, [:identifier], name: :blog_identifier_index)
    update_blogs()
  end

  def update_blogs do
    blogs = Run.Admin.list_blogs()

    for blog <- blogs do
      Run.Admin.update_blog(blog, %{"identifier" => blog.title})
      |> IO.inspect()
    end
  end
end
