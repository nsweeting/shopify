defmodule Shopify.MetafieldTest do
  use ExUnit.Case, async: true

  alias Shopify.Metafield

  test "client can request a single metafield" do
    assert {:ok, response} = Shopify.session() |> Metafield.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/metafields/1.json", "metafield", Metafield.empty_resource())

    assert fixture == response.data
  end

  test "client can request all metafields" do
    assert {:ok, response} = Shopify.session() |> Metafield.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/metafields.json", "metafields", [Metafield.empty_resource()])

    assert fixture == response.data
  end

  test "client can request a metafield count" do
    assert {:ok, response} = Shopify.session() |> Metafield.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/metafields/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create a metafield" do
    fixture =
      Fixture.load("../test/fixtures/metafields/1.json", "metafield", Metafield.empty_resource())

    assert {:ok, response} = Shopify.session() |> Metafield.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/metafields/1.json", "metafield", Metafield.empty_resource())

    assert fixture == response.data
  end

  test "client can request to update a metafield" do
    assert {:ok, response} = Shopify.session() |> Metafield.find(1)
    assert "app_key" == response.data.value
    update = %{response.data | value: "Update"}
    assert {:ok, response} = Shopify.session() |> Metafield.update(1, update)
    assert "Update" == response.data.value
  end

  test "client can request to patch update a metafield" do
    update = %{value: "Update"}
    assert {:ok, response} = Shopify.session() |> Metafield.patch_update(1, update)
    assert "Update" == response.data.value
  end

  test "client can request to delete a metafield" do
    assert {:ok, response} = Shopify.session() |> Metafield.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end

  # These tests are specific to parent resources

  test "client can request a single metafield for product" do
    assert {:ok, response} = Shopify.session() |> Metafield.find_product_metafield(1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/products/1/metafields/1.json",
        "metafield",
        Metafield.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request all metafields for product" do
    assert {:ok, response} = Shopify.session() |> Metafield.all_product_metafields(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/products/1/metafields.json", "metafields", [
        Metafield.empty_resource()
      ])

    assert fixture == response.data
  end

  test "client can request a metafield count for product" do
    assert {:ok, response} = Shopify.session() |> Metafield.count_product_metafields(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/products/1/metafields/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create a metafield for product" do
    fixture =
      Fixture.load(
        "../test/fixtures/products/1/metafields/1.json",
        "metafield",
        Metafield.empty_resource()
      )

    assert {:ok, response} = Shopify.session() |> Metafield.create_product_metafield(1, fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/products/1/metafields/1.json",
        "metafield",
        Metafield.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request to update a metafield for product" do
    assert {:ok, response} = Shopify.session() |> Metafield.find_product_metafield(1, 1)
    assert "produit" == response.data.value
    update = %{response.data | value: "Update"}
    assert {:ok, response} = Shopify.session() |> Metafield.update_product_metafield(1, 1, update)
    assert "Update" == response.data.value
  end

  test "client can request to delete a metafield for product" do
    assert {:ok, response} = Shopify.session() |> Metafield.delete_product_metafield(1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end

  # These tests are specific to parent / child resources

  test "client can request a single metafield for product variant" do
    assert {:ok, response} =
             Shopify.session() |> Metafield.find_product_variant_metafield(1, 1, 1)

    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/products/1/variants/1/metafields/1.json",
        "metafield",
        Metafield.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request all metafields for product variant" do
    assert {:ok, response} = Shopify.session() |> Metafield.all_product_variant_metafields(1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/products/1/variants/1/metafields.json", "metafields", [
        Metafield.empty_resource()
      ])

    assert fixture == response.data
  end

  test "client can request a metafield count for product variant" do
    assert {:ok, response} = Shopify.session() |> Metafield.count_product_variant_metafields(1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/products/1/variants/1/metafields/count.json", "count", nil)

    assert fixture == response.data
  end

  test "client can request to create a metafield for product variant" do
    fixture =
      Fixture.load(
        "../test/fixtures/products/1/variants/1/metafields/1.json",
        "metafield",
        Metafield.empty_resource()
      )

    assert {:ok, response} =
             Shopify.session() |> Metafield.create_product_variant_metafield(1, 1, fixture)

    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/products/1/variants/1/metafields/1.json",
        "metafield",
        Metafield.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request to update a metafield for product variant" do
    assert {:ok, response} =
             Shopify.session() |> Metafield.find_product_variant_metafield(1, 1, 1)

    assert "variante de produit" == response.data.value
    update = %{response.data | value: "Update"}

    assert {:ok, response} =
             Shopify.session() |> Metafield.update_product_variant_metafield(1, 1, 1, update)

    assert "Update" == response.data.value
  end

  test "client can request to delete a metafield for product variant" do
    assert {:ok, response} =
             Shopify.session() |> Metafield.delete_product_variant_metafield(1, 1, 1)

    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
