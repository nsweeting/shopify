defmodule Shopify.DiscountCode do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :amount,
    :code,
    :type
  ]
end
