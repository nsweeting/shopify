defmodule Shopify.EventTest do
  use ExUnit.Case, async: true

  alias Shopify.Event

  test "client can request a single event" do
    assert {:ok, response} = Shopify.session() |> Event.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/events/1.json", "event", Event.empty_resource())
    assert fixture == response.data
  end

  test "client can request all events" do
    assert {:ok, response} = Shopify.session() |> Event.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/events.json", "events", [Event.empty_resource()])
    assert fixture == response.data
  end

  test "client can request a nevent count" do
    assert {:ok, response} = Shopify.session() |> Event.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/events/count.json", "count", nil)
    assert fixture == response.data
  end
end
