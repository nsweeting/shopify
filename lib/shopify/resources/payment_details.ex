defmodule Shopify.PaymentDetails do
  @moduledoc false
  
  @derive [Poison.Encoder]

  defstruct [
    :avs_result_code,
    :credit_card_bin,
    :credit_card_company,
    :credit_card_number,
    :cvv_result_code,
  ]
end