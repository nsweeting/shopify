defmodule Shopify.Order.Fulfillment.Event do
  @singular "event"
  @plural "events"

  use Shopify.NestedResource, import: [:all]

  @doc false
  def empty_resource, do: Shopify.Event.empty_resource()

  @doc false
  def all_url(order_id), do: "orders/#{order_id}/" <> "events.json"
end
