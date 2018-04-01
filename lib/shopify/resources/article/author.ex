defmodule Shopify.Article.Author do
  @singular "author"
  @plural "authors"

  use Shopify.Resource, import: [:all]

  @doc false
  def empty_resource, do: []

  @doc false
  def all_url, do: "articles/" <> @plural <> ".json"
end
