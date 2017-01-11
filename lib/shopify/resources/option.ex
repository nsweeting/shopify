defmodule Shopify.Option do
  @moduledoc false
  
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name,
    :position,
    :product_id,
    :values
  ]
end