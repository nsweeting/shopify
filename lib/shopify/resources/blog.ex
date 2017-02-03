defmodule Shopify.Blog do
  @derive [Poison.Encoder]
  @singular "blog"
  @plural "blogs"
  
  use Shopify.Resource, import: [
    :find,
    :all,
    :create,
    :count,
    :update,
    :delete
  ]

  alias Shopify.{
    Blog
  }

  defstruct [
    :commentable,
    :created_at,
    :feedburner,
    :feedburner_location,
    :handle,
    :id,
    :metafield,
    :tags,
    :template_suffix,
    :title,
    :updated_at
  ]

  @doc false
  def empty_resource do
    %Blog{}
  end

  @doc false
  def find_url(id), do: @plural <>  "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end