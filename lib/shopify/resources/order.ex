defmodule Shopify.Order do
  @derive [Poison.Encoder]
  @singular "order"
  @plural "orders"

  use Shopify.Resource,
    import: [:find, :all, :count, :create, :update, :delete]

  alias Shopify.{
    Order,
    Address,
    Customer,
    PaymentDetails,
    ClientDetails,
    BillingAddress,
    ShippingAddress,
    ShippingLine,
    LineItem,
    DiscountCode,
    Fullfillment,
    TaxLine
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
    :fullfillments,
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

  @doc false
  def empty_resource do
    %Order{
      customer: %Customer{
        default_address: %Address{}
      },
      payment_details: %PaymentDetails{},
      client_details: %ClientDetails{},
      billing_address: %BillingAddress{},
      shipping_address: %ShippingAddress{},
      shipping_lines: [%ShippingLine{}],
      line_items: [%LineItem{}],
      discount_codes: [%DiscountCode{}],
      fullfillments: [%Fullfillment{}],
      tax_lines: [%TaxLine{}]
    }
  end

  @doc false
  def find_url(id), do: @plural <>  "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end