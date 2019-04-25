defmodule Shopify.Checkout do
  @derive [Poison.Encoder]
  @singular "checkout"
  @plural "checkouts"

  use Shopify.Resource,
    import: [
      :all,
      :find,
      :create,
      :update,
      :count
    ]

  alias Shopify.{
    Checkout,
    BillingAddress,
    ShippingAddress,
    Customer,
    LineItem,
    ShippingLine,
    TaxLine,
    DiscountCode,
    Address
  }

  defstruct [
    :abandoned_checkout_url,
    :billing_address,
    :buyer_accepts_marketing,
    :cancel_reason,
    :cart_token,
    :closed_at,
    :completed_at,
    :created_at,
    :currency,
    :customer,
    :discount_codes,
    :email,
    :gateway,
    :landing_site,
    :line_items,
    :note,
    :referring_site,
    :shipping_address,
    :shipping_lines,
    :source_name,
    :subtotal_price,
    :tax_lines,
    :taxes_included,
    :token,
    :total_discounts,
    :total_line_items_price,
    :total_price,
    :total_tax,
    :total_weight,
    :updated_at,
    :order,
    :order_id,
    :customer_id,
    :location_id,
    :device_id,
    :shopify_payments_account_id,
    :user_id
  ]

  @doc false
  def empty_resource do
    %Checkout{
      billing_address: %BillingAddress{},
      shipping_address: %ShippingAddress{},
      customer: %Customer{
        default_address: %Address{}
      },
      line_items: [
        %LineItem{
          tax_lines: [%TaxLine{}]
        }
      ],
      shipping_lines: [%ShippingLine{}],
      tax_lines: [%TaxLine{}],
      discount_codes: [%DiscountCode{}],
      order: %Checkout.Order{}
    }
  end

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def find_url(token), do: @plural <> "/#{token}.json"

  @doc false
  def count_url, do: @plural <> "/count.json"

  @doc """
  Retrieves a list of shipping rates for a token.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - token: A checkout token.

  ## Examples
      iex> Shopify.session |> Shopify.Checkout.shipping_rates("asdfasdfasdf")
      {:ok, %Shopify.Response{}}
  """
  @spec shipping_rates(%Shopify.Session{}, binary) :: {:ok, %__MODULE__{}} | {:error, map}
  def shipping_rates(session, token) do
    session
    |> Request.new(@plural <> "/#{token}/shipping_rates.json", empty_resource())
    |> Client.get()
  end

  @doc """
  Requests to mark a comment as complete.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - token: A checkout token.

  ## Examples
      iex> Shopify.session |> Shopify.Checkout.complete("asdfasdfasdf")
      {:ok, %Shopify.Response{}}
  """
  @spec complete(%Shopify.Session{}, binary) :: {:ok, %__MODULE__{}} | {:error, map}
  def complete(session, token) do
    session
    |> Request.new(@plural <> "/#{token}/complete.json", empty_resource())
    |> Client.post()
  end
end
