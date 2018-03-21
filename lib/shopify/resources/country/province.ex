defmodule Shopify.Country.Province do
  @plural "provinces"
  @singular "province"

  use Shopify.NestedResource, import: [:all, :find, :count, :update]

  defstruct [
    :code,
    :country_id,
    :id,
    :name,
    :shipping_zone_id,
    :tax,
    :tax_name,
    :tax_type,
    :tax_percentage
  ]

  @doc false
  def empty_resource, do: %__MODULE__{}

  @doc false
  def find_url(country_id, id), do: url_prefix(country_id) <> @plural <> "/#{id}.json"

  @doc false
  def all_url(country_id), do: url_prefix(country_id) <> @plural <> ".json"

  @doc false
  def count_url(country_id), do: url_prefix(country_id) <> @plural <> "/count.json"

  defp url_prefix(country_id), do: "countries/#{country_id}/"
end
