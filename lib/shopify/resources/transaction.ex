defmodule Shopify.Transaction do
  @derive [Poison.Encoder]
  @singular "transaction"
  @plural "transactions"

  use Shopify.NestedResource, import: [:find, :all, :create, :count]

  alias Shopify.{Transaction, PaymentDetails}

  defstruct [
    :amount,
    :authorization,
    :created_at,
    :device_id,
    :gateway,
    :source_name,
    :payment_details,
    :id,
    :kind,
    :order_id,
    :receipt,
    :error_code,
    :status,
    :test,
    :user_id,
    :currency
  ]

  @doc false
  def empty_resource do
    %Transaction{
      payment_details: %PaymentDetails{}
    }
  end

  @doc false
  def find_url(id1, id2), do: "orders/#{id1}/" <> @plural <>  "/#{id2}.json"

  @doc false
  def all_url(id1), do: "orders/#{id1}/" <> @plural <> ".json"

  @doc false
  def count_url(id1), do: "orders/#{id1}/" <> @plural <> "/count.json"
end