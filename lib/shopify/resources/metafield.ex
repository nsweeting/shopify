defmodule Shopify.Metafield do
  @moduledoc false
  
  @derive [Poison.Encoder]

  defstruct [
    :created_at,
    :description,
    :id,
    :key,
    :namespace,
    :owner_id,
    :owner_resource,
    :value,
    :value_type,
    :updated_at
  ]
end