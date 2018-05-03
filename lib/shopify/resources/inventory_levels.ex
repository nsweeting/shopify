defmodule Shopify.InventoryLevel do
  @derive [Poison.Encoder]
  @singular "inventory_level"
  @plural "inventory_levels"
  @missing_params_msg "Inventory Levels need an inventory_item_ids or locations_ids parameter."

  use Shopify.Resource,
    import: [
      :delete
    ]

  defstruct [
    :id,
    :sku,
    :tracked,
    :created_at,
    :updated_at
  ]

  @doc false
  def empty_resource do
    %__MODULE__{}
  end

  @doc """
  Requests all resources. Needs an array of inventory item ids or location ids as parameters!

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - params: Any additional query params.

  ## Examples
      iex> Shopify.session |> Shopify.Product.all
      {:ok, %Shopify.Response{}}
  """
  def all(session, params \\ %{})
  def all(%Shopify.Session{} = session, %{inventory_item_ids: _} = params),
    do: do_all(session, params)
  def all(%Shopify.Session{} = session, %{location_ids: _} = params),
    do: do_all(session, params)
  def all(_, _params),
    do: Shopify.Response.new(422, @missing_params_msg, empty_resource())

  defp do_all(session, params) do
    session
    |> Request.new(all_url(), params, plural_resource())
    |> Client.get()
  end

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"
end
