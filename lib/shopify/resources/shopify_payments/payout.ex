defmodule Shopify.ShopifyPayments.Payout do
  @derive [Poison.Encoder]
  @singular "payout"
  @plural "payouts"

  use Shopify.Resource,
    import: [
      :find,
      :all
    ]

  alias Shopify.ShopifyPayments.PayoutSummary

  defstruct [
    :amount,
    :currency,
    :date,
    :id,
    :status,
    :summary
  ]

  @doc false
  def empty_resource do
    %__MODULE__{
      summary: %PayoutSummary{}
    }
  end

  @doc false
  def find_url(id), do: "shopify_payments/#{@plural}/#{id}.json"

  @doc false
  def all_url, do: "shopify_payments/#{@plural}.json"
end
