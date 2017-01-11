defmodule Shopify.Fullfillment do
  @moduledoc false
  
  @derive [Poison.Encoder]

  defstruct [
    :created_at,
    :id,
    :line_items,
    :order_id,
    :receipt,
    :status,
    :tracking_company,
    :tracking_number,
    :updated_at
  ]
end