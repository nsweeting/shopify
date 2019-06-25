defmodule Shopify.InventoryLevel do
  @derive [Poison.Encoder]
  @singular "inventory_level"
  @plural "inventory_levels"

  @missing_all_params_msg "InventoryLevel.all/2 needs an inventory_item_ids or locations_ids parameter."
  @missing_adjustment_parameters "InventoryLevel.adjust/2 needs an inventory_item_id, location_id, and available_adjustment parameter."
  @missing_connect_parameters "InventoryLevel.connect/2 needs an inventory_item_id, and a location_id parameter."

  use Shopify.Resource,
    import: [
      :delete
    ]

  defstruct [
    :available,
    :inventory_item_id,
    :location_id,
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
    - params: Can be inventory_item_ids or location_ids or both.

  ## Examples
      iex> Shopify.session |> Shopify.InventoryLevel.all(%{inventory_item_ids: [123]})
      {:ok, %Shopify.Response{}}
  """
  @spec all(%Shopify.Session{}, map) ::
          {:ok, Shopify.Response.t()} | {:error, Shopify.Response.t()}
  def all(session, params)

  def all(%Shopify.Session{} = session, %{inventory_item_ids: _} = params),
    do: do_all(session, params)

  def all(%Shopify.Session{} = session, %{location_ids: _} = params), do: do_all(session, params)
  def all(%Shopify.Session{}, _params), do: unprocessable_entity(@missing_all_params_msg)

  defp do_all(session, params) do
    session
    |> Request.new(all_url(), params, plural_resource())
    |> Client.get()
  end

  @doc """
  Adjusts the inventory for a given inventory item at a given location.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - params: Any additional query params.

  ## Examples
      iex> Shopify.session |> Shopify.InventoryLevel.adjust(%{inventory_item_id: 123, location_id: 123, available_adjustment: 123})
      {:ok, %Shopify.Response{}}
  """
  @spec adjust(%Shopify.Session{}, map) ::
          {:ok, Shopify.Response.t()} | {:error, Shopify.Response.t()}
  def adjust(
        %Shopify.Session{} = session,
        %{inventory_item_id: _, location_id: _, available_adjustment: _} = inventory_level
      ) do
    session
    |> Request.new(@plural <> "/adjust.json", inventory_level, singular_resource())
    |> Client.post()
  end

  def adjust(%Shopify.Session{}, _), do: unprocessable_entity(@missing_adjustment_parameters)

  @doc """
  Connects a given inventory with a location.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - params: Any additional query params.

  ## Examples
      iex> Shopify.session |> Shopify.InventoryLevel.connect(%{inventory_item_id: 123, location_id: 123})
      {:ok, %Shopify.Response{}}
  """
  @spec connect(%Shopify.Session{}, map) ::
          {:ok, Shopify.Response.t()} | {:error, Shopify.Response.t()}
  def connect(%Shopify.Session{} = session, %{inventory_item_id: _, location_id: _} = connection) do
    session
    |> Request.new(@plural <> "/connect.json", connection, singular_resource())
    |> Client.post()
  end

  def connect(%Shopify.Session{}, _), do: unprocessable_entity(@missing_connect_parameters)

  @doc """
  Sets available inventory for a given inventory item at given location.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - params: Any additional query params.

  ## Examples
      iex> Shopify.session |> Shopify.InventoryLevel.set(%{inventory_item_id: 123, location_id: 123, available: 5})
      {:ok, %Shopify.Response{}}
  """
  @spec set(%Shopify.Session{}, map) ::
          {:ok, Shopify.Response.t()} | {:error, Shopify.Response.t()}
  def set(
        %Shopify.Session{} = session,
        %{inventory_item_id: _, location_id: _, available: _} = inventory
      ) do
    session
    |> Request.new(@plural <> "/set.json", inventory, singular_resource())
    |> Client.post()
  end

  def set(%Shopify.Session{}, _), do: unprocessable_entity(@missing_connect_parameters)

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  defp unprocessable_entity(msg), do: Shopify.Response.new(422, msg, empty_resource())
end
