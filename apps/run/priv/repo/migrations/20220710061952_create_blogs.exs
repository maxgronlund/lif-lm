defmodule Run.Repo.Migrations.CreateBlogs do
  use Ecto.Migration

  def change do
    create table(:blogs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :page, :string
      add :title, :string
      add :description, :text
      add :image, :string

      timestamps()
    end

    unique_index(:blog, [:page, :title], name: :blogs_page_title_index)
    unique_index(:blogs, [:title])
  end
end
