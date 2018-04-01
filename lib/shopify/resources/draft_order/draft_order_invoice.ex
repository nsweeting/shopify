defmodule Shopify.DraftOrder.DraftOrderInvoice do
  @singular "draft_order_invoice"
  @plural "draft_order_invoices"
  @derive [Poison.Encoder]

  use Shopify.NestedResource, import: [:create]

  defstruct [
    :to,
    :from,
    :bcc,
    :subject,
    :custom_message
  ]

  def empty_resource do
    %__MODULE__{}
  end

  def find_url(draft_order_id, id),
    do: "draft_orders/#{draft_order_id}/" <> @plural <> "/#{id}.json"

  def all_url(draft_order_id), do: "draft_orders/#{draft_order_id}/" <> @plural <> ".json"
end
