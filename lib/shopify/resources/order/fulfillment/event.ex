defmodule Shopify.Order.Fulfillment.Event do
  @singular "fulfillment_event"
  @plural "fulfillment_events"

  use Shopify.Resource

  defstruct [
    :id,
    :fulfillment_id,
    :status,
    :message,
    :happened_at,
    :city,
    :province,
    :country,
    :zip,
    :address1,
    :latitude,
    :longitude,
    :shop_id,
    :estimated_delivery_at,
    :order_id
  ]

  @doc false
  def empty_resource, do: %__MODULE__{}

  def all(%Shopify.Session{} = session, order_id, fulfillment_id, params \\ %{}) do
    session
    |> Request.new(all_url(order_id, fulfillment_id), params, plural_resource())
    |> Client.get()
  end

  def find(%Shopify.Session{} = session, order_id, fulfillment_id, event_id, params \\ %{}) do
    session
    |> Request.new(find_url(order_id, fulfillment_id, event_id), params, singular_resource())
    |> Client.get()
  end

  def create(%Session{} = session, order_id, fulfillment_id, new_resource) do
    body = new_resource |> to_json

    session
    |> Request.new(all_url(order_id, fulfillment_id), %{}, singular_resource(), body)
    |> Client.post()
  end

  def delete(%Session{} = session, order_id, fulfillment_id, event_id) do
    session
    |> Request.new(find_url(order_id, fulfillment_id, event_id), %{}, nil)
    |> Client.delete()
  end

  @doc false
  def all_url(order_id, fulfillment_id), do: base_url(order_id, fulfillment_id) <> ".json"

  @doc false
  def find_url(order_id, fulfillment_id, event_id),
    do: base_url(order_id, fulfillment_id) <> "/#{event_id}.json"

  defp base_url(order_id, fulfillment_id),
    do: "orders/#{order_id}/fulfillments/#{fulfillment_id}/events"
end
