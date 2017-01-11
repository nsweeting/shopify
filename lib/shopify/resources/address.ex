defmodule Shopify.Address do
  @moduledoc false
  
  @derive [Poison.Encoder]

  defstruct [
    :address1,
    :address2,
    :city,
    :company,
    :country,
    :coutry_code,
    :country_name,
    :default,
    :first_name,
    :id,
    :last_name,
    :name,
    :phone,
    :province,
    :province_code,
    :zip
  ]
end