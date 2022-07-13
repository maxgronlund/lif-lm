defmodule Run.Admin.Post do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias Run.Uploader.Image

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :author, :string
    field :body, :string
    field :title, :string
    field :identifier, :string
    field :image, Image.Type

    belongs_to :blog, Run.Admin.Blog

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :author, :blog_id, :identifier])
    |> validate_required([:title, :body])
    |> unique_constraint(:post_blog_id_identifier_index)
    |> unique_constraint(:post_identifier_index)
    |> cast_attachments(attrs, [:image])
  end
end
