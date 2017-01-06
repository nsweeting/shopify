defmodule Shopify.Option do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
    :position,
    :product_id,
    :values
  ]
end