defmodule Shopify.FulfillmentTest do
  use ExUnit.Case, async: true

  alias Shopify.Fulfillment

  test "client can request a single fulfillment" do
    assert {:ok, response} = Shopify.session() |> Fulfillment.find(1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/orders/1/fulfillments/1.json", "fulfillment", Fulfillment.empty_resource())
    assert fixture == response.data
  end

  test "client can request all fulfillments" do
    assert {:ok, response} = Shopify.session() |> Fulfillment.all(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/orders/1/fulfillments.json", "fulfillments", [Fulfillment.empty_resource()])
    assert fixture == response.data
  end

  test "client can request a fulfillment count" do
    assert {:ok, response} = Shopify.session() |> Fulfillment.count(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/orders/1/fulfillments/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create a fulfillment" do
    fixture = Fixture.load("../test/fixtures/orders/1/fulfillments/1.json", "fulfillment", Fulfillment.empty_resource())
    assert {:ok, response} = Shopify.session() |> Fulfillment.create(1, fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/orders/1/fulfillments/1.json", "fulfillment", Fulfillment.empty_resource())
    assert fixture == response.data
  end

  test "client can request to update a fulfillment" do
    assert {:ok, response} = Shopify.session() |> Fulfillment.find(1, 1)
    assert is_nil(response.data.tracking_company)
    update = %{response.data | tracking_company: "Update"}
    assert {:ok, response} = Shopify.session() |> Fulfillment.update(1, 1, update)
    assert "Update" == response.data.tracking_company
  end

  test "client can request to complete a fulfillment" do
    assert {:ok, response} = Shopify.session() |> Fulfillment.complete(1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/orders/1/fulfillments/1/complete.json", "fulfillment", Fulfillment.empty_resource())
    assert fixture == response.data
  end

  test "client can request to open a fulfillment" do
    assert {:ok, response} = Shopify.session() |> Fulfillment.open(1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/orders/1/fulfillments/1/open.json", "fulfillment", Fulfillment.empty_resource())
    assert fixture == response.data
  end

  test "client can request to cancel a fulfillment" do
    assert {:ok, response} = Shopify.session() |> Fulfillment.cancel(1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/orders/1/fulfillments/1/cancel.json", "fulfillment", Fulfillment.empty_resource())
    assert fixture == response.data
  end
end
