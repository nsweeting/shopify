defmodule Shopify.Order do
  @derive [Poison.Encoder]
  @singular "order"
  @plural "orders"

  use Shopify.Resource,
    import: [
      :find,
      :all,
      :count,
      :create,
      :update,
      :delete
    ]

  alias Shopify.{
    Order,
    Attribute,
    Address,
    Customer,
    PaymentDetails,
    ClientDetails,
    BillingAddress,
    ShippingAddress,
    ShippingLine,
    LineItem,
    DiscountCode,
    Fulfillment,
    TaxLine
  }

  defstruct [
    :billing_address,
    :browser_ip,
    :buyer_accepts_marketing,
    :cancel_reason,
    :cancelled_at,
    :cart_token,
    :client_details,
    :closed_at,
    :created_at,
    :currency,
    :customer,
    :discount_codes,
    :email,
    :financial_status,
    :fulfillments,
    :fulfillment_status,
    :tags,
    :id,
    :landing_site,
    :line_items,
    :location_id,
    :name,
    :note,
    :note_attributes,
    :number,
    :order_number,
    :payment_details,
    :payment_gateway_names,
    :phone,
    :processed_at,
    :processing_method,
    :referring_site,
    :refunds,
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
    :user_id,
    :order_status_url,
    :landing_site_ref,
    :checkout_token,
    :confirmed,
    :test,
    :total_price_usd,
    :gateway,
    :source_url,
    :checkout_id,
    :contact_email,
    :device_id,
    :source_identifier,
    :reference,
    :transactions
  ]

  @doc false
  def empty_resource do
    %Order{
      customer: %Customer{
        default_address: %Address{},
        addresses: [%Address{}]
      },
      payment_details: %PaymentDetails{},
      client_details: %ClientDetails{},
      billing_address: %BillingAddress{},
      shipping_address: %ShippingAddress{},
      shipping_lines: [%ShippingLine{}],
      line_items: [
        %LineItem{
          properties: [%Attribute{}],
          tax_lines: [%TaxLine{}]
        }
      ],
      discount_codes: [%DiscountCode{}],
      fulfillments: [
        %Fulfillment{
          line_items: [
            %LineItem{
              properties: [%Attribute{}],
              tax_lines: [%TaxLine{}]
            }
          ]
        }
      ],
      tax_lines: [%TaxLine{}],
      note_attributes: [%Attribute{}]
    }
  end

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"

  defp non_rest_url(id, sub_url), do: @plural <> "/#{id}/#{sub_url}.json"

  defp non_rest_post(session, id, sub_url, opts \\ %{}) do
    session
    |> Request.new(non_rest_url(id, sub_url), opts, empty_resource())
    |> Client.post()
  end

  @doc """
  Requests to close an order, see https://help.shopify.com/en/api/reference/orders/order#close.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - id: The id of the resource.

  ## Examples
      iex> Shopify.session |> Shopify.Order.close(1)
      {:ok, %Shopify.Response{}}
  """
  @spec close(%Shopify.Session{}, integer) :: {:ok, %__MODULE__{}} | {:error, map}
  def close(session, id) do
    session |> non_rest_post(id, "close")
  end

  @doc """
  Requests to open an order, see https://help.shopify.com/en/api/reference/orders/order#open.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - id: The id of the resource.

  ## Examples
      iex> Shopify.session |> Shopify.Order.open(1)
      {:ok, %Shopify.Response{}}
  """
  @spec open(%Shopify.Session{}, integer) :: {:ok, %__MODULE__{}} | {:error, map}
  def open(session, id) do
    session |> non_rest_post(id, "open")
  end

  @doc """
  Requests to open an order, see https://help.shopify.com/en/api/reference/orders/order#cancel.
  amount

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ### Options
  * *amount* The amount to refund. If set, Shopify attempts to void or refund the payment, depending on its status.

  * *currency* The currency of the refund that's issued when the order is canceled. Required for multi-currency orders whenever the amount property is provided.

  * *restock* (_deprecated_) Whether to restock refunded items back to your store's inventory.

  * *reason* The reason for the order cancellation. Valid values: customer, inventory, fraud, declined, and other.)

  * *email* Whether to send an email to the customer notifying them of the cancellation.

  * *refund* The refund transactions to perform. Required for some more complex refund situations. For more information, see the Refund API.

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - id: The id of the resource.

  ## Examples
      iex> Shopify.session() |> Shopify.Order.cancel(1)
      {:ok, %Shopify.Response{}}

      iex> Shopify.session() |> Shopify.Order.cancel(1, %{restock: true, amount: 120, currency: "USD"})
      {:ok, %Shopify.Response{}}
  """
  @spec cancel(%Shopify.Session{}, integer) :: {:ok, %__MODULE__{}} | {:error, map}
  def cancel(session, id, opts \\ %{}) do
    session |> non_rest_post(id, "cancel", opts)
  end
end
