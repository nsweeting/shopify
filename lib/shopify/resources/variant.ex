defmodule Shopify.Variant do
  @moduledoc false
  
  @derive [Poison.Encoder]

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
    :metafield,
    :option,
    :position,
    :price,
    :product_id,
    :requires_shipping,
    :sku,
    :taxable,
    :title,
    :updated_at
  ]
end