defmodule Shopify.FulfillmentService do
  @derive [Poison.Encoder]
  @singular "fulfillment_service"
  @plural "fulfillment_services"

  use Shopify.Resource,
    import: [
      :find,
      :all,
      :create,
      :update,
      :delete
    ]

  defstruct [
    :callback_url,
    :format,
    :handle,
    :inventory_management,
    :location_id,
    :name,
    :provider_id,
    :requires_shipping_method,
    :tracking_support
  ]

  @doc false
  def empty_resource do
    %__MODULE__{}
  end

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"
end
