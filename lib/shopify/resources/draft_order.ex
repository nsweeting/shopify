defmodule Shopify.DraftOrder do
  @derive [Poison.Encoder]
  @singular "draft_order"
  @plural "draft_orders"

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
    Attribute,
    Address,
    Customer,
    BillingAddress,
    ShippingAddress,
    ShippingLine,
    LineItem,
    TaxLine,
    DraftOrder.DraftOrderInvoice
  }

  defstruct [
    :id,
    :order_id,
    :name,
    :customer,
    :shipping_address,
    :billing_address,
    :note,
    :note_attributes,
    :email,
    :currency,
    :invoice_sent_at,
    :invoice_url,
    :line_items,
    :shipping_line,
    :tags,
    :tax_exempt,
    :tax_lines,
    :applied_discount,
    :taxes_included,
    :total_tax,
    :subtotal_price,
    :total_price,
    :completed_at,
    :created_at,
    :updated_at,
    :status
  ]

  @doc false
  def empty_resource do
    %__MODULE__{
      customer: %Customer{
        default_address: %Address{},
        addresses: [%Address{}]
      },
      billing_address: %BillingAddress{},
      shipping_address: %ShippingAddress{},
      shipping_line: %ShippingLine{},
      line_items: [
        %LineItem{
          properties: [%Attribute{}],
          tax_lines: [%TaxLine{}]
        }
      ],
      tax_lines: [%TaxLine{}],
      note_attributes: [%Attribute{}]
    }
  end

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def count_url, do: @plural <> "/count.json"

  defp put_complete(session, id, params) do
    url = @plural <> "/#{id}/complete.json"

    session
    |> Request.new(url, params, singular_resource())
    |> Client.put()
  end

  @doc """
  Requests to complete the order.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - id: The id of the draft order.

  ## Examples
      iex> Shopify.session |> Shopify.DraftOrder.complete(1)
      {:ok, %Shopify.Response{}}
  """
  @spec complete(%Shopify.Session{}, integer) :: {:ok, %__MODULE__{}} | {:error, map}
  def complete(session, id, params \\ %{}), do: put_complete(session, id, params)

  @doc """
  Requests to send an invoice for the draft order.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - id: The id of the draft order.
    - draft_order_invoice: A `%Shopify.DraftOrder.DraftOrderInvoice{}` struct.

  ## Examples
      iex> Shopify.session |> Shopify.DraftOrder.send_invoice(1, %Shopify.DraftOrder.DraftOrderInvoice{})
      {:ok, %Shopify.Response{}}
  """
  @spec complete(%Shopify.Session{}, integer, %DraftOrderInvoice{}) ::
          {:ok, %__MODULE__{}} | {:error, map}
  def send_invoice(session, id, draft_order_invoice),
    do: session |> DraftOrderInvoice.create(id, draft_order_invoice)
end
