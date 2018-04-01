defmodule Shopify.DraftOrderInvoiceTest do
  use ExUnit.Case, async: true

  alias Shopify.DraftOrder.DraftOrderInvoice

  test "client can request to create an draft_order_invoice" do
    fixture =
      Fixture.load(
        "../test/fixtures/draft_orders/1/send_invoice.json",
        "draft_order_invoice",
        DraftOrderInvoice.empty_resource()
      )

    assert {:ok, response} = Shopify.session() |> DraftOrderInvoice.create(1, fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/draft_orders/1/send_invoice.json",
        "draft_order_invoice",
        DraftOrderInvoice.empty_resource()
      )

    assert fixture == response.data
  end
end
