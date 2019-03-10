defmodule Shopify.ProductTest do
  use ExUnit.Case, async: true

  alias Shopify.Product

  test "client can request a single product" do
    assert {:ok, response} = Shopify.session() |> Product.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/products/1.json", "product", Product.empty_resource())

    assert fixture == response.data
  end

  test "client can request all products" do
    assert {:ok, response} = Shopify.session() |> Product.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/products.json", "products", [Product.empty_resource()])

    assert fixture == response.data
  end

  test "client can request a product count" do
    assert {:ok, response} = Shopify.session() |> Product.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/products/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create a product" do
    fixture =
      Fixture.load("../test/fixtures/products/1.json", "product", Product.empty_resource())

    assert {:ok, response} = Shopify.session() |> Product.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/products/1.json", "product", Product.empty_resource())

    assert fixture == response.data
  end

  test "client can request to update a product" do
    assert {:ok, response} = Shopify.session() |> Product.find(1)
    assert "IPod Nano - 8GB" == response.data.title
    update = %{response.data | title: "Update"}
    assert {:ok, response} = Shopify.session() |> Product.update(1, update)
    assert "Update" == response.data.title
  end

  test "client can request to patch update a product" do
    update = %{title: "Update"}
    assert {:ok, response} = Shopify.session() |> Product.patch_update(1, update)
    assert "Update" == response.data.title
  end

  test "client can request to delete a product" do
    assert {:ok, response} = Shopify.session() |> Product.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
