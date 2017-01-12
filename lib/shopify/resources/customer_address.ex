defmodule Shopify.CustomerAddress do
  @derive [Poison.Encoder]
  @singular "customer_address"
  @plural "addresses"

  use Shopify.NestedResource, import: [:find, :all, :create, :delete]

  alias Shopify.{CustomerAddress}

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
    :country_name
  ]

  @doc false
  def empty_resource do
    %CustomerAddress{}
  end

  @doc false
  def find_url(id1, id2), do: "customers/#{id1}/" <> @plural <>  "/#{id2}.json"

  @doc false
  def all_url(id1), do: "customers/#{id1}/" <> @plural <> ".json"
end