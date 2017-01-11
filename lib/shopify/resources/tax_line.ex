defmodule Shopify.TaxLine do
  @moduledoc false
  
  @derive [Poison.Encoder]

  defstruct [
    :price,
    :rate,
    :title
  ]
end