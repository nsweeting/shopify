defmodule Shopify.CustomerAddress do
  @derive [Poison.Encoder]
  @singular "customer_address"
  @plural "addresses"

  use Shopify.NestedResource,
    import: [
      :find,
      :all,
      :create,
      :delete
    ]

  alias Shopify.{
    CustomerAddress
  }

  defstruct [
    :address1,
    :address2,
    :city,
    :company,
    :first_name,
    :last_name,
    :phone,
    :province,
    :country,
    :zip,
    :name,
    :province_code,
    :country_code,
    :country_name,
    :id
  ]

  @doc false
  def empty_resource do
    %CustomerAddress{}
  end

  @doc false
  def find_url(top_id, nest_id) do
    "customers/#{top_id}/" <> @plural <> "/#{nest_id}.json"
  end

  @doc false
  def all_url(top_id), do: "customers/#{top_id}/" <> @plural <> ".json"
end
