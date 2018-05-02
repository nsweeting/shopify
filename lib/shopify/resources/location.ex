defmodule Shopify.Location do
  @derive [Poison.Encoder]
  @singular "location"
  @plural "locations"

  use Shopify.Resource,
    import: [
      :find,
      :all,
      :count
    ]

  defstruct [
    :id,
    :name,
    :deleted_at,
    :address1,
    :address2,
    :city,
    :zip,
    :province,
    :country,
    :phone,
    :created_at,
    :updated_at,
    :country_code,
    :country_name,
    :province_code,
    :legacy
  ]

  @doc false
  def empty_resource, do: %__MODULE__{}

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end
