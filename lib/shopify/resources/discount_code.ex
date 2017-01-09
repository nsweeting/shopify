defmodule Shopify.DiscountCode do
  @derive [Poison.Encoder]

  defstruct [
    :amount,
    :code,
    :type
  ]
end