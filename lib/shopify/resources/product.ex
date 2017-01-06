defmodule Shopify.Product do
  @derive [Poison.Encoder]
  @resource "product"
  @resources "products"

  use Shopify.Base
  use Shopify.Count

  alias Shopify.{Product, Variant, Image, Option}

  defstruct [
    :body_html,
    :created_at,
    :handle,
    :id,
    :images,
    :options,
    :product_type,
    :published_at,
    :published_scope,
    :tags,
    :template_suffix,
    :title,
    :metafields_global_title_tag,
    :metafields_global_description_tag,
    :updated_at,
    :variants,
    :vendor
  ]

  def new do
    %Product{
      variants: [%Variant{}],
      images: [%Image{}],
      options: [%Option{}]
    }
  end
end