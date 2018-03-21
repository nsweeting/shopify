defmodule Shopify.CountryTest do
  use ExUnit.Case, async: true

  alias Shopify.Country

  test "client can request a single country" do
    assert {:ok, response} = Shopify.session() |> Country.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/countries/1.json", "country", Country.empty_resource())
    assert fixture == response.data
  end

  test "client can request all countries" do
    assert {:ok, response} = Shopify.session() |> Country.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/countries.json", "countries", [Country.empty_resource()])
    assert fixture == response.data
  end

  test "client can request a ncountry count" do
    assert {:ok, response} = Shopify.session() |> Country.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/countries/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create an country" do
    fixture = Fixture.load("../test/fixtures/countries/1.json", "country", Country.empty_resource())
    assert {:ok, response} = Shopify.session() |> Country.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/countries/1.json", "country", Country.empty_resource())
    assert fixture == response.data
  end

  test "client can request to update an country" do
    assert {:ok, response} = Shopify.session() |> Country.find(1)
    assert "CA" == response.data.code
    update = %{response.data | code: "Update"}
    assert {:ok, response} = Shopify.session() |> Country.update(1, update)
    assert "Update" == response.data.code
  end

  test "client can request to delete an country" do
    assert {:ok, response} = Shopify.session() |> Country.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
