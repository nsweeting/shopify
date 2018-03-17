defmodule Shopify.Refund do
  @moduledoc false

  @derive [Poison.Encoder]
  @singular "refund"
  @plural "refunds"

  use Shopify.NestedResource,
    import: [
      :find,
      :all,
      :create
    ]

  alias Shopify.{
    Refund
  }

  defstruct [
    :created_at,
    :processed_at,
    :id,
    :note,
    :refund_line_items,
    :restock,
    :transactions,
    :user_id
  ]

  @doc false
  def empty_resource do
    %Refund{}
  end

  @doc false
  def find_url(top_id, nest_id) do
    "orders/#{top_id}/" <> @plural <> "/#{nest_id}.json"
  end

  @doc false
  def all_url(top_id), do: "orders/#{top_id}/" <> @plural <> ".json"

  @doc false
  def calculate_url(top_id) do
    @plural <> "orders/#{top_id}/" <> @plural <> "/calculate.json"
  end
end
