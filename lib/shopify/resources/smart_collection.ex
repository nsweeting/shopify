defmodule Shopify.SmartCollection do
  @derive [Poison.Encoder]
  @singular "smart_collection"
  @plural "smart_collections"

  use Shopify.Resource,
    import: [
      :find,
      :all,
      :create,
      :count,
      :update,
      :delete
    ]

  alias Shopify.{
    SmartCollection
  }

  defstruct [
    :body_html,
    :handle,
    :id,
    :image,
    :published,
    :published_at,
    :published_scope,
    :rules,
    :disjunctive,
    :sort_order,
    :template_suffix,
    :title,
    :updated_at
  ]

  @doc false
  def empty_resource do
    %SmartCollection{}
  end

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end
