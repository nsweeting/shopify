defmodule Shopify.Image do
  @moduledoc false
  
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