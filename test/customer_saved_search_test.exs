defmodule Shopify.CustomerSavedSearchTest do
  use ExUnit.Case, async: true

  alias Shopify.CustomerSavedSearch

  test "client can request a single customer_saved_search" do
    assert {:ok, response} = Shopify.session() |> CustomerSavedSearch.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/customer_saved_searches/1.json",
        "customer_saved_search",
        CustomerSavedSearch.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request all customer_saved_searches" do
    assert {:ok, response} = Shopify.session() |> CustomerSavedSearch.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/customer_saved_searches.json", "customer_saved_searches", [
        CustomerSavedSearch.empty_resource()
      ])

    assert fixture == response.data
  end

  test "client can request a ncustomer_saved_search count" do
    assert {:ok, response} = Shopify.session() |> CustomerSavedSearch.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/customer_saved_searches/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create an customer_saved_search" do
    fixture =
      Fixture.load(
        "../test/fixtures/customer_saved_searches/1.json",
        "customer_saved_search",
        CustomerSavedSearch.empty_resource()
      )

    assert {:ok, response} = Shopify.session() |> CustomerSavedSearch.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/customer_saved_searches/1.json",
        "customer_saved_search",
        CustomerSavedSearch.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request to update an customer_saved_search" do
    assert {:ok, response} = Shopify.session() |> CustomerSavedSearch.find(1)
    assert "Accepts Marketing" == response.data.name
    update = %{response.data | name: "Update"}
    assert {:ok, response} = Shopify.session() |> CustomerSavedSearch.update(1, update)
    assert "Update" == response.data.name
  end

  test "client can request to delete an customer_saved_search" do
    assert {:ok, response} = Shopify.session() |> CustomerSavedSearch.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
