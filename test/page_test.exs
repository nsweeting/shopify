defmodule Shopify.PageTest do
  use ExUnit.Case, async: true

  alias Shopify.Page

  test "client can request a single page" do
    assert {:ok, response} = Shopify.session() |> Page.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/pages/1.json", "page", Page.empty_resource())
    assert fixture == response.data
  end

  test "client can request all pages" do
    assert {:ok, response} = Shopify.session() |> Page.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/pages.json", "pages", [Page.empty_resource()])
    assert fixture == response.data
  end

  test "client can request a npage count" do
    assert {:ok, response} = Shopify.session() |> Page.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/pages/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create an page" do
    fixture = Fixture.load("../test/fixtures/pages/1.json", "page", Page.empty_resource())
    assert {:ok, response} = Shopify.session() |> Page.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/pages/1.json", "page", Page.empty_resource())
    assert fixture == response.data
  end

  test "client can request to update an page" do
    assert {:ok, response} = Shopify.session() |> Page.find(1)
    assert "Warranty information" == response.data.title
    update = %{response.data | title: "Update"}
    assert {:ok, response} = Shopify.session() |> Page.update(1, update)
    assert "Update" == response.data.title
  end

  test "client can request to delete an page" do
    assert {:ok, response} = Shopify.session() |> Page.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
