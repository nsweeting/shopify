defmodule Shopify.DiscountCode do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :code,
    :created_at,
    :updated_at,
    :id,
    :price_rule_id,
    :usage_count
  ]  
end
