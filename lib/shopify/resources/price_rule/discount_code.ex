defmodule Shopify.PriceRule.DiscountCode do
  @derive [Poison.Encoder]
  @singular "discount_code"
  @plural "discount_codes"

  use Shopify.NestedResource, import: [
    :find,
    :all,
    :create,
    :update,
    :delete
  ]

  defstruct [
    :id,
    :price_rule_id,
    :code,
    :usage_count,
    :created_at,
    :updated_at
  ]

  @doc false
  def empty_resource do
    %Shopify.PriceRule.DiscountCode{}
  end

  @doc false
  def find_url(price_rule_id, id), do: url_prefix(price_rule_id) <>  @plural <>  "/#{id}.json"

  @doc false
  def all_url(price_rule_id), do: url_prefix(price_rule_id) <> @plural <> ".json"

  @doc false
  defp url_prefix(price_rule_id), do: "price_rules/#{price_rule_id}/"
end
