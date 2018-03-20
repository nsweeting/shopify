defmodule Shopify.Theme do
  @derive [Poison.Encoder]
  @singular "theme"
  @plural "themes"

  use Shopify.Resource, import: [
    :all,
    :find,
    :create,
    :delete,
    :update
  ]

  defstruct [
    :created_at,
    :id,
    :name,
    :previewable,
    :processing,
    :role,
    :theme_store_id,
    :updated_at
  ]

  @doc false
  def empty_resource, do: %__MODULE__{}

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"
end
