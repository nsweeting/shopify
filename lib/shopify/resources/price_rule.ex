defmodule Shopify.PriceRule do
  @derive [Poison.Encoder]
  @singular "price_rule"
  @plural "price_rules"

  use Shopify.Resource, import: [
    :find,
    :all,
    :create,
    :update,
    :delete
  ]

  defstruct [
    :id,
    :value_type,
    :value,
    :customer_selection,
    :target_type,
    :target_selection,
    :allocation_method,
    :once_per_customer,
    :usage_limit,
    :starts_at,
    :ends_at,
    :created_at,
    :updated_at,
    :prerequisite_subtotal_range,
    :prerequisite_shipping_price_range,
    :title,
    :entitled_product_ids,
    :entitled_variant_ids,
    :entitled_collection_ids,
    :entitled_country_ids,
    :prerequisite_saved_search_ids,
    :discount_codes
  ]

  @doc false
  def empty_resource do
    %Shopify.PriceRule{}
  end

  @doc false
  def find_url(id), do: @plural <>  "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"
end
