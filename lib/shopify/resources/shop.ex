defmodule Shopify.Shop do
  @derive [Poison.Encoder]

  alias Shopify.{Shop, Client, Request}

  defstruct [
    :address1,
    :address2,
    :city,
    :country,
    :country_code,
    :country_name,
    :created_at,
    :updated_at,
    :customer_email,
    :currency,
    :domain,
    :email,
    :google_apps_domain,
    :google_apps_login_enabled,
    :id,
    :latitude,
    :longitude,
    :money_format,
    :money_with_currency_format,
    :weight_unit,
    :myshopify_domain,
    :name,
    :plan_name,
    :has_discounts,
    :has_gift_cards,
    :plan_display_name,
    :password_enabled,
    :phone,
    :primary_locale,
    :province,
    :province_code,
    :shop_owner,
    :source,
    :force_ssl,
    :tax_shipping,
    :taxes_included,
    :county_taxes,
    :timezone,
    :iana_timezone,
    :zip,
    :has_storefront,
    :setup_required
  ]

  @doc """
  Requests details for the shop relevant to the session.

  Returns `{:ok, shop}` or `{:error, %Shopify.Error{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    
  ## Examples
      iex> Shopify.session |> Shopify.Shop.current
      {:ok, %Shopify.Shop{}}
  """
  def current(session) do
    session
    |> Request.new("shop.json", %{}, %{"shop" => %Shop{}})
    |> Client.get()
  end
end
