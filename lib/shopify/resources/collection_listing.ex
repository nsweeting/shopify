defmodule Shopify.CollectionListing do
  @derive [Poison.Encoder]
  @singular "collection_listing"
  @plural "collection_listings"

  use Shopify.NestedResource,
    import: [
      :find,
      :all
    ]

  alias Shopify.{
    CollectionListing
  }

  defstruct [
    :id,
    :collection_id,
    :body_html,
    :default_product_image,
    :image,
    :handle,
    :published_at,
    :title,
    :sort_order,
    :updated_at
  ]

  @doc false
  def empty_resource do
    %CollectionListing{}
  end

  @doc false
  def find_url(id) do
    @plural <> "/#{id}.json"
  end

  @doc false
  def all_url(), do: @plural <> ".json"
end
