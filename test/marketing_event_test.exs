defmodule Shopify.MarketingEventTest do
  use ExUnit.Case, async: true

  alias Shopify.MarketingEvent

  test "client can request a single marketing_event" do
    assert {:ok, response} = Shopify.session() |> MarketingEvent.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/marketing_events/1.json", "marketing_event", MarketingEvent.empty_resource())
    assert fixture == response.data
  end

  test "client can request all marketing_events" do
    assert {:ok, response} = Shopify.session() |> MarketingEvent.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/marketing_events.json", "marketing_events", [MarketingEvent.empty_resource()])
    assert fixture == response.data
  end

  test "client can request a nmarketing_event count" do
    assert {:ok, response} = Shopify.session() |> MarketingEvent.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/marketing_events/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create an marketing_event" do
    fixture = Fixture.load("../test/fixtures/marketing_events/1.json", "marketing_event", MarketingEvent.empty_resource())
    assert {:ok, response} = Shopify.session() |> MarketingEvent.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/marketing_events/1.json", "marketing_event", MarketingEvent.empty_resource())
    assert fixture == response.data
  end

  test "client can request to update an marketing_event" do
    assert {:ok, response} = Shopify.session() |> MarketingEvent.find(1)
    assert "facebook" == response.data.utm_source
    update = %{response.data | utm_source: "Update"}
    assert {:ok, response} = Shopify.session() |> MarketingEvent.update(1, update)
    assert "Update" == response.data.utm_source
  end

  test "client can request to delete an marketing_event" do
    assert {:ok, response} = Shopify.session() |> MarketingEvent.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
