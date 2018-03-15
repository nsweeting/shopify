defmodule Shopify.Metafield do
  @derive [Poison.Encoder]
  @singular "metafield"
  @plural "metafields"

  use Shopify.Resource, import: [
    :find,
    :all,
    :count,
    :create,
    :update,
    :delete
  ]

  alias __MODULE__

  defstruct [
    :created_at,
    :description,
    :id,
    :key,
    :namespace,
    :owner_id,
    :owner_resource,
    :value,
    :value_type,
    :updated_at
  ]

  @doc false
  def empty_resource do
    %Metafield{}
  end

  @doc false
  def find_url(id), do: @plural <>  "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end
