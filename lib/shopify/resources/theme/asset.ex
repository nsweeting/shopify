defmodule Shopify.Theme.Asset do
  @derive [Poison.Encoder]
  @singular "asset"
  @plural "assets"

  alias Shopify.{Client, Request, Session}

  use Shopify.NestedResource,
    import: [
      :all,
      :find,
      :delete
    ]

  defstruct [
    :attachment,
    :content_type,
    :created_at,
    :key,
    :public_url,
    :size,
    :source_key,
    :src,
    :theme_id,
    :updated_at,
    :value
  ]

  @doc false
  def empty_resource, do: %__MODULE__{}

  @doc false
  def all_url(theme_id), do: url_prefix(theme_id) <> "/assets.json"

  @doc false
  def find_url(theme_id, key), do: url_prefix(theme_id) <> "/assets.json?asset[key]=" <> key

  @doc false
  defp url_prefix(theme_id), do: "themes/#{theme_id}"

  @doc """
  Requests to create a new resource.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - top_id: The id of the top-level resource.
    - new_resource: A struct of the resource being created.

  ## Examples
      iex> Shopify.session |> Shopify.Theme.Asset.create(theme_id)
      {:ok, %Shopify.Response{}}
  """
  def create(%Session{} = session, top_id, new_resource) do
    body = new_resource |> to_json

    session
    |> Request.new(all_url(top_id), %{}, empty_resource(), body)
    |> Client.put()
  end

  @doc """
  Requests to update a resource by id.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Error{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - top_id: The id of the top-level resource.
    - updated_resource: A struct of the resource being updated.

  ## Examples
      iex> Shopify.session |> Shopify.Theme.Asset.update(theme_id)
      {:ok, %Shopify.Response{}}
  """
  def update(%Session{} = session, top_id, updated_resource) do
    body = updated_resource |> to_json

    session
    |> Request.new(all_url(top_id), %{}, empty_resource(), body)
    |> Client.put()
  end
end
