defmodule Shopify.Order.Fulfillment.EventTest do
  use ExUnit.Case, async: true

  alias Shopify.Order.Fulfillment.Event

  test "client can request a single event" do
    assert {:ok, response} = Shopify.session() |> Event.find(1, 1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/orders/1/fulfillments/1/events/1.json",
        "fulfillment_event",
        Event.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request all events" do
    assert {:ok, response} = Shopify.session() |> Event.all(1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/orders/1/fulfillments/1/events.json", "fulfillment_events", [
        Event.empty_resource()
      ])

    assert fixture == response.data
  end

  test "client can request to create a event" do
    fixture =
      Fixture.load(
        "../test/fixtures/orders/1/fulfillments/1/events/1.json",
        "fulfillment_event",
        Event.empty_resource()
      )

    assert {:ok, response} = Shopify.session() |> Event.create(1, 1, fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/orders/1/fulfillments/1/events/1.json",
        "fulfillment_event",
        Event.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request to delete an event" do
    assert {:ok, response} = Shopify.session() |> Event.delete(1, 1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
