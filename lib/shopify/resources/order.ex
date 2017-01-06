defmodule Shopify.Order do
  @derive [Poison.Encoder]
  @resource "order"
  @resources "orders"

  use Shopify.Base
  use Shopify.Count

  alias Shopify.{
    Order,
    PaymentDetails,
    ClientDetails,
    BillingAddress,
    LineItem
  }

  defstruct [
    :billing_address,
    :browser_ip,
    :buyer_accepts_marketing,
    :cancel_reason,
    :cancelled_at,
    :cart_token,
    :client_details,
    :closed_at,
    :created_at,
    :currency,
    :customer,
    :discount_codes,
    :email,
    :financial_status,
    :fulfillments,
    :fulfillment_status,
    :tags,
    :id,
    :landing_site,
    :line_items,
    :location_id,
    :name,
    :note,
    :note_attributes,
    :number,
    :order_number,
    :payment_details,
    :payment_gateway_names,
    :processed_at,
    :processing_method,
    :referring_site,
    :refunds,
    :shipping_address,
    :shipping_lines,
    :source_name,
    :subtotal_price,
    :tax_lines,
    :taxes_included,
    :token,
    :total_discounts,
    :total_line_items_price,
    :total_price,
    :total_tax,
    :total_weight,
    :updated_at,
    :user_id,
    :order_status_url
  ]

  def new do
    %Order{
      payment_details: %PaymentDetails{},
      client_details: %ClientDetails{},
      billing_address: %BillingAddress{},
      line_items: [%LineItem{}]
    }
  end
end