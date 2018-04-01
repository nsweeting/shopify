defmodule Shopify.Article do
  @moduledoc false

  @derive [Poison.Encoder]
  @singular "article"
  @plural "articles"

  alias Shopify.{
    Image,
    Metafield
  }

  use Shopify.NestedResource,
    import: [
      :all,
      :find,
      :create,
      :count,
      :update,
      :delete
    ]

  defstruct [
    :author,
    :blog_id,
    :body_html,
    :created_at,
    :id,
    :handle,
    :image,
    :metafields,
    :published,
    :published_at,
    :summary_html,
    :tags,
    :template_suffix,
    :title,
    :updated_at,
    :user_id
  ]

  @doc false
  def empty_resource do
    %__MODULE__{
      image: %Image{},
      metafields: [%Metafield{}]
    }
  end

  @doc false
  def all_url(blog_id), do: url_prefix(blog_id) <> @plural <> ".json"

  @doc false
  def find_url(blog_id, id), do: url_prefix(blog_id) <> @plural <> "/#{id}.json"

  @doc false
  def count_url(blog_id), do: url_prefix(blog_id) <> @plural <> "/count.json"

  @doc false
  def url_prefix(blog_id), do: "blogs/#{blog_id}/"
end
