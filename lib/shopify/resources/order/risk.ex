defmodule Shopify.Order.Risk do
  @singular "risk"
  @plural "risks"

  use Shopify.NestedResource,
    import: [
      :create,
      :find,
      :all,
      :update,
      :delete
    ]

  defstruct [
    :id,
    :order_id,
    :checkout_id,
    :source,
    :score,
    :recommendation,
    :display,
    :cause_cancel,
    :message,
    :merchant_message
  ]

  @doc false
  def empty_resource, do: %__MODULE__{}

  @doc false
  def all_url(order_id), do: base_url(order_id) <> ".json"

  @doc false
  def find_url(order_id, id), do: base_url(order_id) <> "/#{id}.json"

  @doc false
  def base_url(order_id), do: "orders/#{order_id}/" <> @plural
end
