defmodule Shopify.ProductListingTest do
  use ExUnit.Case, async: true

  alias Shopify.ProductListing

  test "client can request a single product_listing" do
    assert {:ok, response} = Shopify.session() |> ProductListing.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/product_listings/1.json", "product_listing", ProductListing.empty_resource())
    assert fixture == response.data
  end

  test "client can request all product_listings" do
    assert {:ok, response} = Shopify.session() |> ProductListing.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/product_listings.json", "product_listings", [ProductListing.empty_resource()])
    assert fixture == response.data
  end

  test "client can request a nproduct_listing count" do
    assert {:ok, response} = Shopify.session() |> ProductListing.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/product_listings/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create an product_listing" do
    fixture = Fixture.load("../test/fixtures/product_listings/1.json", "product_listing", ProductListing.empty_resource())
    assert {:ok, response} = Shopify.session() |> ProductListing.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/product_listings/1.json", "product_listing", ProductListing.empty_resource())
    assert fixture == response.data
  end

  test "client can request to update an product_listing" do
    assert {:ok, response} = Shopify.session() |> ProductListing.find(1)
    assert "ipod-touch" == response.data.handle
    update = %{response.data | handle: "ipod-dont-touch"}
    assert {:ok, response} = Shopify.session() |> ProductListing.update(1, update)
    assert "ipod-dont-touch" == response.data.handle
  end

  test "client can request to delete an product_listing" do
    assert {:ok, response} = Shopify.session() |> ProductListing.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end

  test "client can request product ids" do
    {success, resp} = Shopify.session() |> ProductListing.product_ids()

    assert success == :ok
    assert resp.data == [921728736, 632910392]
  end
end
