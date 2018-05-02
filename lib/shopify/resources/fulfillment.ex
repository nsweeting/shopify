defmodule Shopify.Fulfillment do
  @derive [Poison.Encoder]

  defstruct [
    :created_at,
    :id,
    :line_items,
    :location_id,
    :notify_customer,
    :order_id,
    :receipt,
    :service,
    :shipment_status,
    :status,
    :tracking_company,
    :tracking_number,
    :tracking_numbers,
    :tracking_url,
    :tracking_urls,
    :updated_at,
    :variant_inventory_management
  ]
end
