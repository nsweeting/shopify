defmodule Shopify.CustomerSavedSearch do
  @plural "customer_saved_searches"
  @singular "customer_saved_search"

  use Shopify.Resource, import: [:all, :find, :create, :update, :delete, :count]

  defstruct [
    :created_at,
    :id,
    :name,
    :query,
    :updated_at
  ]

  @doc false
  def empty_resource, do: %__MODULE__{}

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end
