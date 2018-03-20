defmodule Shopify.Article.Tag do
  @plural "tags"
  @singular "tag"

  use Shopify.Resource, import: [:all]

  @doc false
  def empty_resource, do: []

  @doc false
  def all_url, do: "articles/" <> @plural <> ".json"
end
