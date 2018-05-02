defmodule Shopify.Fulfillment do
  @derive [Poison.Encoder]
  @singular "fulfillment"
  @plural "fulfillments"

  use Shopify.NestedResource,
    import: [
      :find,
      :all,
      :count,
      :create,
      :update
    ]

  alias Shopify.LineItem

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

  @doc false
  def empty_resource do
    %__MODULE__{
      line_items: [%LineItem{}]
    }
  end

  @doc false
  def find_url(top_id, nest_id), do: base_url(top_id)<> "/#{nest_id}.json"

  @doc false
  def all_url(top_id), do: base_url(top_id) <> ".json"

  @doc false
  def count_url(top_id), do: base_url(top_id) <> "/count.json"

  defp base_url(top_id), do: "orders/#{top_id}/" <> @plural

  defp non_rest_post(session, top_id, nest_id, sub_url) do
    session
    |> Request.new(non_rest_url(top_id, nest_id, sub_url), %{"fulfillment" => empty_resource()})
    |> Client.post()
  end

  defp non_rest_url(top_id, nest_id, sub_url), do: base_url(top_id) <> "/#{nest_id}/#{sub_url}.json"

  @doc """
  Request to mark a fulfillment as complete.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - top_id: The id of the top level resource.
    - nest_id: The id of the requested nested resource.

  ## Examples
      iex> Shopify.session |> Shopify.Fulfillment.complete(1, 1)
      {:ok, %Shopify.Response{}}
  """
  @spec complete(%Shopify.Session{}, integer, integer) :: {:ok, %__MODULE__{}} | {:error, map}
  def complete(session, top_id, nest_id) do
    session |> non_rest_post(top_id, nest_id, "complete")
  end

  @doc """
  Request to transition a fulfillment from pending to open.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - top_id: The id of the top level resource.
    - nest_id: The id of the requested nested resource.

  ## Examples
      iex> Shopify.session |> Shopify.Fulfillment.open(1, 1)
      {:ok, %Shopify.Response{}}
  """
  @spec open(%Shopify.Session{}, integer, integer) :: {:ok, %__MODULE__{}} | {:error, map}
  def open(session, top_id, nest_id) do
    session |> non_rest_post(top_id, nest_id, "open")
  end

  @doc """
  Request to cancel a fulfillment.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - top_id: The id of the top level resource.
    - nest_id: The id of the requested nested resource.

  ## Examples
      iex> Shopify.session |> Shopify.Fulfillment.cancel(1, 1)
      {:ok, %Shopify.Response{}}
  """
  @spec cancel(%Shopify.Session{}, integer, integer) :: {:ok, %__MODULE__{}} | {:error, map}
  def cancel(session, top_id, nest_id) do
    session |> non_rest_post(top_id, nest_id, "cancel")
  end
end
