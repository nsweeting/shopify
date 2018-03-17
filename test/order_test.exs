defmodule Shopify.OrderTest do
  use ExUnit.Case, async: true

  alias Shopify.Order

  test "client can request a single order" do
    assert {:ok, response} = Shopify.session() |> Order.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/orders/1.json", "order", Order.empty_resource())
    assert fixture == response.data
  end

  test "client can request all orders" do
    assert {:ok, response} = Shopify.session() |> Order.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/orders.json", "orders", [Order.empty_resource()])
    assert fixture == response.data
  end

  test "client can request a norder count" do
    assert {:ok, response} = Shopify.session() |> Order.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/orders/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create an order" do
    fixture = Fixture.load("../test/fixtures/orders/1.json", "order", Order.empty_resource())
    assert {:ok, response} = Shopify.session() |> Order.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/orders/1.json", "order", Order.empty_resource())
    assert fixture == response.data
  end

  test "client can request to update an order" do
    assert {:ok, response} = Shopify.session() |> Order.find(1)
    assert "fhwdgads" == response.data.reference
    update = %{response.data | reference: "Update"}
    assert {:ok, response} = Shopify.session() |> Order.update(1, update)
    assert "Update" == response.data.reference
  end

  test "client can request to delete an order" do
    assert {:ok, response} = Shopify.session() |> Order.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
