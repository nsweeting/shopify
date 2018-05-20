defmodule Shopify.Customer.Order do
  @singular "order"
  @plural "orders"

  use Shopify.NestedResource, import: [:all]

  alias Shopify.{
    Order
  }

  defstruct %Order{} |> Map.keys() |> List.delete(:__struct__)

  def empty_resource,
    do: Order.empty_resource()

  @doc false
  def all_url(customer_id), do: "customers/#{customer_id}/" <> @plural <> ".json"
end
