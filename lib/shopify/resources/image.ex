defmodule Shopify.Image do
  @derive [Poison.Encoder]

  defstruct [
    :created_at,
    :id,
    :position,
    :product_id,
    :src,
    :updated_at,
    :variant_ids
  ]
end