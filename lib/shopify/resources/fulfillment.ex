defmodule Shopify.Fulfillment do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :created_at,
    :id,
    :line_items,
    :order_id,
    :receipt,
    :status,
    :tracking_company,
    :tracking_number,
    :tracking_numbers,
    :tracking_url,
    :tracking_urls,
    :updated_at,
    :service,
    :shipment_status
  ]
end
