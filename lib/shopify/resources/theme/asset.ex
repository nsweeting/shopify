defmodule Shopify.Theme.Asset do
  @derive [Poison.Encoder]
  @singular "asset"
  @plural "assets"

  use Shopify.NestedResource,
    import: [
      :all,
      :find,
      :delete
    ]

  defstruct [
    :attachment,
    :content_type,
    :created_at,
    :key,
    :public_url,
    :size,
    :source_key,
    :src,
    :theme_id,
    :updated_at,
    :value
  ]

  @doc false
  def empty_resource, do: %__MODULE__{}

  @doc false
  def all_url(theme_id), do: url_prefix(theme_id) <> "/assets.json"

  @doc false
  def find_url(theme_id, key), do: url_prefix(theme_id) <> "/assets.json?asset[key]=" <> key

  @doc false
  defp url_prefix(theme_id), do: "themes/#{theme_id}"
end
