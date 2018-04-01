defmodule Shopify.Product.Event do
  @singular "event"
  @plural "events"

  use Shopify.NestedResource, import: [:all]

  @doc false
  def empty_resource, do: Shopify.Event.empty_resource()

  @doc false
  def all_url(product_id), do: "products/#{product_id}/" <> "events.json"
end
