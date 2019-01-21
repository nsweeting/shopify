defmodule Shopify.InventoryItem do
  @derive [Poison.Encoder]
  @singular "inventory_item"
  @plural "inventory_items"

  use Shopify.Resource,
    import: [
      :find,
      :all,
      :update
    ]

  defstruct [
    :id,
    :sku,
    :cost,
    :tracked,
    :created_at,
    :updated_at
  ]

  @doc false
  def empty_resource do
    %__MODULE__{}
  end

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"
end
