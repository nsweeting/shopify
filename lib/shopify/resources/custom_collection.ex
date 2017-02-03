defmodule Shopify.CustomCollection do
  @derive [Poison.Encoder]
  @singular "custom_collection"
  @plural "custom_collections"
   
  use Shopify.Resource, import: [
    :find,
    :all,
    :create,
    :count,
    :update,
    :delete
  ]

  alias Shopify.{
    CustomCollection
  }

  defstruct [
    :body_html,
    :handle,
    :image,
    :id,
    :metafield,
    :published,
    :published_at,
    :published_scope,
    :sort_order,
    :template_suffix,
    :title,
    :updated_at
  ]

  @doc false
  def empty_resource do
    %CustomCollection{}
  end

  @doc false
  def find_url(id), do: @plural <>  "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end