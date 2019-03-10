defmodule Shopify.FulfillmentServiceTest do
  use ExUnit.Case, async: true

  alias Shopify.FulfillmentService

  test "client can request a single fulfillment_service" do
    assert {:ok, response} = Shopify.session() |> FulfillmentService.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/fulfillment_services/1.json",
        "fulfillment_service",
        FulfillmentService.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request all fulfillment_services" do
    assert {:ok, response} = Shopify.session() |> FulfillmentService.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/fulfillment_services.json", "fulfillment_services", [
        FulfillmentService.empty_resource()
      ])

    assert fixture == response.data
  end

  test "client can request to create a fulfillment_service" do
    fixture =
      Fixture.load(
        "../test/fixtures/fulfillment_services/1.json",
        "fulfillment_service",
        FulfillmentService.empty_resource()
      )

    assert {:ok, response} = Shopify.session() |> FulfillmentService.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/fulfillment_services/1.json",
        "fulfillment_service",
        FulfillmentService.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request to update a fulfillment_service" do
    assert {:ok, response} = Shopify.session() |> FulfillmentService.find(1)
    assert "MarsFulfillment" == response.data.name
    update = %{response.data | name: "Update"}
    assert {:ok, response} = Shopify.session() |> FulfillmentService.update(1, update)
    assert "Update" == response.data.name
  end

  test "client can request to patch update a fulfillment_service" do
    update = %{name: "Update"}
    assert {:ok, response} = Shopify.session() |> FulfillmentService.patch_update(1, update)
    assert "Update" == response.data.name
  end

  test "client can request to delete a fulfillment_service" do
    assert {:ok, response} = Shopify.session() |> FulfillmentService.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
