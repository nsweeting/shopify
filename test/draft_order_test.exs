defmodule Shopify.DraftOrderTest do
  use ExUnit.Case, async: true

  alias Shopify.{
    DraftOrder,
    DraftOrder.DraftOrderInvoice
  }

  test "client can request a single draft_order" do
    assert {:ok, response} = Shopify.session() |> DraftOrder.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/draft_orders/1.json",
        "draft_order",
        DraftOrder.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request all draft_orders" do
    assert {:ok, response} = Shopify.session() |> DraftOrder.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/draft_orders.json", "draft_orders", [
        DraftOrder.empty_resource()
      ])

    assert fixture == response.data
  end

  test "client can request a ndraft_order count" do
    assert {:ok, response} = Shopify.session() |> DraftOrder.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/draft_orders/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create an draft_order" do
    fixture =
      Fixture.load(
        "../test/fixtures/draft_orders/1.json",
        "draft_order",
        DraftOrder.empty_resource()
      )

    assert {:ok, response} = Shopify.session() |> DraftOrder.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/draft_orders/1.json",
        "draft_order",
        DraftOrder.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request to update an draft_order" do
    assert {:ok, response} = Shopify.session() |> DraftOrder.find(1)
    assert "open" == response.data.status
    update = %{response.data | status: "Update"}
    assert {:ok, response} = Shopify.session() |> DraftOrder.update(1, update)
    assert "Update" == response.data.status
  end

  test "client can request to delete an draft_order" do
    assert {:ok, response} = Shopify.session() |> DraftOrder.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end

  test "client can request to send an invoice for the draft order" do
    fixture =
      Fixture.load(
        "../test/fixtures/draft_orders/1/send_invoice.json",
        "draft_order_invoice",
        DraftOrderInvoice.empty_resource()
      )

    assert {:ok, response} = Shopify.session() |> DraftOrder.send_invoice(1, fixture)
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

  test "client can request to complete a draft_order" do
    assert {:ok, response} = Shopify.session() |> DraftOrder.complete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/draft_orders/1/complete.json",
        "draft_order",
        DraftOrder.empty_resource()
      )

    assert fixture == response.data
  end
end
