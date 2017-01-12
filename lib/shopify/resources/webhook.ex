defmodule Shopify.Webhook do
  @derive[Poison.Encoder]
  @singular "webhook"
  @plural "webhooks"

  use Shopify.Resource,
    import: [:find, :all, :count, :create, :update, :delete]

  alias Shopify.{Webhook}

  defstruct [
    :address,
    :created_at,
    :fields,
    :format,
    :id,
    :metafield_namespaces,
    :topic,
    :updated_at
  ]

  @doc false
  def empty_resource do
    %Webhook{}
  end

  @doc false
  def find_url(id), do: @plural <>  "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end