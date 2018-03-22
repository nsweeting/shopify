defmodule Shopify.CustomerSavedSearch.Customer do
  @singular "customer"
  @plural "customers"

  use Shopify.NestedResource, import: [:all]

  defstruct %Shopify.Customer{} |> Map.keys() |> List.delete(:__struct__)

  def empty_resource,
    do: %__MODULE__{addresses: [%Shopify.Address{}], default_address: %Shopify.Address{}}

  @doc false
  def all_url(css_id), do: "customer_saved_searches/#{css_id}/" <> @plural <> ".json"
end
