defmodule Shopify.Page do
  @singular "page"
  @plural "pages"

  use Shopify.Resource,
    import: [
      :find,
      :all,
      :count,
      :create,
      :update,
      :delete
    ]

  alias Shopify.Metafield

  defstruct [
    :id,
    :title,
    :shop_id,
    :handle,
    :body_html,
    :author,
    :created_at,
    :updated_at,
    :published_at,
    :template_suffix,
    :published,
    :metafields
  ]

  @doc false
  def empty_resource, do: %__MODULE__{metafields: [%Metafield{}]}

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end
