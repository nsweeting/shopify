defmodule Shopify.ShopifyPayments.PayoutSummary do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :adjustments_fee_amount,
    :adjustments_gross_amount,
    :charges_fee_amount,
    :charges_gross_amount,
    :refunds_fee_amount,
    :refunds_gross_amount,
    :reserved_funds_fee_amount,
    :reserved_funds_gross_amount,
    :retried_payouts_fee_amount,
    :retried_payouts_gross_amount
  ]
end
