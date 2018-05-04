defmodule Shopify.ProductListing do
  @plural "product_listings"
  @singular "product_listing"

  use Shopify.Resource,
    import: [
      :create,
      :all,
      :find,
      :update,
      :delete,
      :count
    ]

  defstruct [
    :product_id,
    :created_at,
    :updated_at,
    :body_html,
    :handle,
    :product_type,
    :title,
    :vendor,
    :available,
    :tags,
    :published_at,
    :variants,
    :images,
    :options
  ]

  alias Shopify.Variant

  @doc false
  def empty_resource, do: %__MODULE__{variants: [%Variant{}]}

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def count_url, do: @plural <> "/count.json"

  def product_ids(session) do
    url = @plural <> "/product_ids.json"

    session
    |> Request.new(url, %{}, %{"product_ids" => []})
    |> Client.get()
  end
end
