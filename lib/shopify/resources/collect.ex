defmodule Shopify.Collect do
  @derive [Poison.Encoder]
  @singular "collect"
  @plural "collects"

  use Shopify.Resource,
    import: [
      :find,
      :all,
      :create,
      :count,
      :delete
    ]

  alias Shopify.{
    Collect
  }

  defstruct [
    :collection_id,
    :created_at,
    :id,
    :position,
    :product_id,
    :sort_value,
    :updated_at
  ]

  @doc false
  def empty_resource do
    %Collect{}
  end

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end
