defmodule Shopify.LocationTest do
  use ExUnit.Case, async: true

  alias Shopify.Location

  test "client can request a single location" do
    assert {:ok, response} = Shopify.session() |> Location.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/locations/1.json", "location", Location.empty_resource())
    assert fixture == response.data
  end

  test "client can request all locations" do
    assert {:ok, response} = Shopify.session() |> Location.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/locations.json", "locations", [Location.empty_resource()])
    assert fixture == response.data
  end

  test "client can request a nlocation count" do
    assert {:ok, response} = Shopify.session() |> Location.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/locations/count.json", "count", nil)
    assert fixture == response.data
  end
end
