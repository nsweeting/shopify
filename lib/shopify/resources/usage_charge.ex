defmodule Shopify.UsageCharge do
  @derive [Poison.Encoder]
  @singular "usage_charge"
  @plural "usage_charges"

  use Shopify.NestedResource,
    import: [
      :find,
      :all,
      :create
    ]

  alias Shopify.{
    UsageCharge
  }

  defstruct [
    :created_at,
    :description,
    :id,
    :price,
    :recurring_application_charge_id,
    :updated_at
  ]

  @doc false
  def empty_resource do
    %UsageCharge{}
  end

  @doc false
  def find_url(top_id, nest_id) do
    "recurring_application_charges/#{top_id}/" <> @plural <> "/#{nest_id}.json"
  end

  @doc false
  def all_url(top_id) do
    "recurring_application_charges/#{top_id}/" <> @plural <> ".json"
  end
end
