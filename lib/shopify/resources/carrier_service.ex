defmodule Shopify.CarrierService do
  @derive [Poison.Encoder]
  @singular "carrier_service"
  @plural "carrier_services"
  
  use Shopify.Resource, import: [
    :find,
    :all,
    :create,
    :update,
    :delete
  ]

  alias Shopify.{
    CarrierService
  }

  defstruct [
    :active,
    :callback_url,
    :carrier_service_type,
    :name,
    :service_discovery,
    :format
  ]

  @doc false
  def empty_resource do
    %CarrierService{}
  end

  @doc false
  def find_url(id), do: @plural <>  "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"
end