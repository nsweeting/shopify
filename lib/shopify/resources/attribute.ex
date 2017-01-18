defmodule Shopify.Attribute do
  @moduledoc false
  
  @derive [Poison.Encoder]

  defstruct [
    :name,
    :value
  ]
end