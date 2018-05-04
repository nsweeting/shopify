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
  def find_url(top_id, nest_id) do
    "applications/#{top_id}/" <> @plural <> "/#{nest_id}.json"
  end

  @doc false
  def all_url(top_id), do: "applications/#{top_id}/" <> @plural <> ".json"
end
