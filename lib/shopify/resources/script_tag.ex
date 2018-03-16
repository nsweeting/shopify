defmodule Shopify.ScriptTag do
  @derive [Poison.Encoder]
  @singular "script_tag"
  @plural "script_tags"

  use Shopify.Resource,
    import: [
      :find,
      :all,
      :create,
      :count,
      :delete
    ]

  alias Shopify.{
    ScriptTag
  }

  defstruct [
    :created_at,
    :event,
    :id,
    :src,
    :display_scope,
    :updated_at
  ]

  @doc false
  def empty_resource do
    %ScriptTag{}
  end

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end
