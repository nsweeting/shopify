defmodule Shopify.RefundLineItem do
  @moduledoc false
  
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :quantity,
    :line_item_id,
    :subtotal,
    :total_tax,
    :line_item
  ]
end