defmodule Run.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :body, :text
      add :author, :string
      add :identifier, :string
      add :image, :string
      add :blog_id, references(:blogs, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:posts, [:blog_id])
    unique_index(:posts, [:blog_id, :identifier], name: :post_blog_id_identifier_index)
    unique_index(:posts, [:identifier], name: :post_identifier_index)
  end
end
