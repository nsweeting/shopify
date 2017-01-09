defmodule Shopify.Customer do
  @derive [Poison.Encoder]
  @singular "customer"
  @plural "customers"

  use Shopify.Resource,
    import: [:find, :all, :count, :create, :update, :delete, :search]

  alias Shopify.{Customer, Address}

  defstruct [
    :accepts_marketing,
    :addresses,
    :created_at,
    :default_address,
    :email,
    :first_name,
    :id,
    :metafield,
    :multipass_identifier,
    :last_name,
    :last_order_id,
    :last_order_name,
    :note,
    :orders_count,
    :state,
    :tags,
    :tax_exempt,
    :total_spent,
    :updated_at,
    :verified_email
  ]

  def empty_resource do
    %Customer{
      addresses: [%Address{}],
      default_address: %Address{}
    }
  end

  def find_url(id), do: @plural <>  "/#{id}.json"

  def all_url, do: @plural <> ".json"

  def count_url, do: @plural <> "/count.json"

  def search_url, do: @plural <> "/search.json"
end