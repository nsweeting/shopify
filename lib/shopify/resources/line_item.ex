defmodule Shopify.LineItem do
  @derive [Poison.Encoder]

  defstruct [
    :fulfillable_quantity,
    :fulfillment_service,
    :fulfillment_status,
    :grams,
    :id,
    :price,
    :product_id,
    :quantity,
    :requires_shipping,
    :sku,
    :title,
    :variant_id,
    :variant_title,
    :vendor,
    :name,
    :gift_card,
    :properties,
    :taxable,
    :tax_lines,
    :total_discount
  ]
end