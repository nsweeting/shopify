defmodule Shopify.Variant do
  @derive [Poison.Encoder]
  @singular "variant"
  @plural "variants"

  use Shopify.Resource, import: [
    :find,
    :all,
    :count,
    :create,
    :update,
    :delete
  ]

  alias __MODULE__

  defstruct [
    :barcode,
    :compare_at_price,
    :created_at,
    :fulfillment_service,
    :grams,
    :weight,
    :weight_unit,
    :id,
    :inventory_management,
    :inventory_policy,
    :inventory_quantity,
    :option1,
    :option2,
    :option3,
    :position,
    :price,
    :product_id,
    :requires_shipping,
    :sku,
    :taxable,
    :title,
    :updated_at
  ]
 
  @doc false
  def empty_resource do
    %Variant{}
  end

  @doc false
  def find_url(id), do: @plural <>  "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end
