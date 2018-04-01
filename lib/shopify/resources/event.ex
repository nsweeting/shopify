defmodule Shopify.Event do
  @derive [Poison.Encoder]
  @singular "event"
  @plural "events"

  use Shopify.Resource, import: [
    :find,
    :all,
    :count
  ]

  defstruct [
    :arguments,
    :body,
    :created_at,
    :id,
    :description,
    :path,
    :message,
    :subject_id,
    :subject_type,
    :verb
  ]

  @doc false
  def empty_resource, do: %__MODULE__{}

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end
