defmodule Shopify.Customer do
  @derive [Poison.Encoder]
  @resource "customer"
  @resources "customers"

  use Shopify.Base
  use Shopify.Count
  use Shopify.Search

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

  def new do
    %Customer{
      addresses: [%Address{}],
      default_address: %Address{}
    }
  end
end