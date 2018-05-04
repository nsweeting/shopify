defmodule Shopify.Policy do
  @plural "policies"
  @singular "policy"

  use Shopify.Resource,
    import: [:all]

  defstruct [
    :title,
    :body,
    :created_at,
    :updated_at,
    :url
  ]

  @doc false
  def empty_resource, do: %__MODULE__{}

  @doc false
  def all_url, do: @plural <> ".json"
end
