defmodule Shopify.TaxLine do
  @derive [Poison.Encoder]

  defstruct [
    :price,
    :rate,
    :title
  ]
end