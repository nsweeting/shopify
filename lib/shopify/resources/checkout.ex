defmodule Shopify.Checkout do
  @derive [Poison.Encoder]
  @singular "checkout"
  @plural "checkouts"

  use Shopify.Resource,
    import: [
      :all,
      :count
    ]

  alias Shopify.{
    Checkout,
    BillingAddress,
    ShippingAddress,
    Customer,
    LineItem,
    ShippingLine,
    TaxLine,
    DiscountCode,
    Address
  }

  defstruct [
    :abandoned_checkout_url,
    :billing_address,
    :buyer_accepts_marketing,
    :cancel_reason,
    :cart_token,
    :closed_at,
    :completed_at,
    :created_at,
    :currency,
    :customer,
    :discount_codes,
    :email,
    :gateway,
    :id,
    :landing_site,
    :line_items,
    :note,
    :referring_site,
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
    :updated_at
  ]

  @doc false
  def empty_resource do
    %Checkout{
      billing_address: %BillingAddress{},
      shipping_address: %ShippingAddress{},
      customer: %Customer{
        default_address: %Address{}
      },
      line_items: [
        %LineItem{
          tax_lines: [%TaxLine{}]
        }
      ],
      shipping_lines: [%ShippingLine{}],
      tax_lines: [%TaxLine{}],
      discount_codes: [%DiscountCode{}]
    }
  end

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end
