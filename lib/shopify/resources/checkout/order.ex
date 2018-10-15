defmodule Shopify.Checkout.Order do
  defstruct [
    :id,
    :name,
    :status_url
  ]

  @doc false
  def empty_resource, do: %__MODULE__{}
end
