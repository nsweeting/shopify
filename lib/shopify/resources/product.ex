defmodule Shopify.Product do
  @derive [Poison.Encoder]
  @singular "product"
  @plural "products"

  use Shopify.Resource,
    import: [
      :find,
      :all,
      :count,
      :create,
      :update,
      :delete
    ]

  alias Shopify.{
    Product,
    Variant,
    Image,
    Option
  }

  defstruct [
    :body_html,
    :created_at,
    :handle,
    :id,
    :images,
    :options,
    :product_type,
    :published_at,
    :published_scope,
    :tags,
    :template_suffix,
    :title,
    :updated_at,
    :variants,
    :vendor
  ]

  @doc false
  def empty_resource do
    %Product{
      variants: [%Variant{}],
      images: [%Image{}],
      options: [%Option{}]
    }
  end

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end
