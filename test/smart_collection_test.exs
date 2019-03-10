defmodule Shopify.SmartCollectionTest do
  use ExUnit.Case, async: true

  alias Shopify.SmartCollection

  test "client can request a single smart_collection" do
    assert {:ok, response} = Shopify.session() |> SmartCollection.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/smart_collections/1.json",
        "smart_collection",
        SmartCollection.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request all smart_collections" do
    assert {:ok, response} = Shopify.session() |> SmartCollection.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/smart_collections.json", "smart_collections", [
        SmartCollection.empty_resource()
      ])

    assert fixture == response.data
  end

  test "client can request a nsmart_collection count" do
    assert {:ok, response} = Shopify.session() |> SmartCollection.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/smart_collections/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create an smart_collection" do
    fixture =
      Fixture.load(
        "../test/fixtures/smart_collections/1.json",
        "smart_collection",
        SmartCollection.empty_resource()
      )

    assert {:ok, response} = Shopify.session() |> SmartCollection.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/smart_collections/1.json",
        "smart_collection",
        SmartCollection.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request to update an smart_collection" do
    assert {:ok, response} = Shopify.session() |> SmartCollection.find(1)
    assert "Smart iPods" == response.data.title
    update = %{response.data | title: "Update"}
    assert {:ok, response} = Shopify.session() |> SmartCollection.update(1, update)
    assert "Update" == response.data.title
  end

  test "client can request to patch update an smart_collection" do
    update = %{title: "Update"}
    assert {:ok, response} = Shopify.session() |> SmartCollection.patch_update(1, update)
    assert "Update" == response.data.title
  end

  test "client can request to delete an smart_collection" do
    assert {:ok, response} = Shopify.session() |> SmartCollection.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
