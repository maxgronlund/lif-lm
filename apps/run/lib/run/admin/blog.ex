defmodule Run.Admin.Blog do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias Run.Uploader.Image

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "blogs" do
    field :identifier, :string
    field :description, :string
    field :page, :string
    field :title, :string
    field :image, Image.Type
    field :link, :string
    has_many :posts, Run.Admin.Post

    timestamps()
  end

  @doc false
  def changeset(blog, attrs) do
    blog
    |> cast(attrs, [:identifier, :page, :title, :description, :link])
    |> validate_required([:page, :title, :description])
    |> unique_constraint(:blogs_page_title_index)
    |> cast_attachments(attrs, [:image])
  end
end
