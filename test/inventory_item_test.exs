defmodule Shopify.InventoryItemTest do
  use ExUnit.Case, async: true

  alias Shopify.InventoryItem

  test "client can request a single inventory_item" do
    assert {:ok, response} = Shopify.session() |> InventoryItem.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/inventory_items/1.json", "inventory_item", InventoryItem.empty_resource())
    assert fixture == response.data
  end

  test "client can request all inventory_items" do
    assert {:ok, response} = Shopify.session() |> InventoryItem.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/inventory_items.json", "inventory_items", [InventoryItem.empty_resource()])
    assert fixture == response.data
  end

  test "client can request to update a inventory_item" do
    assert {:ok, response} = Shopify.session() |> InventoryItem.find(1)
    assert "new sku" == response.data.sku
    update = %{response.data | sku: "Update"}
    assert {:ok, response} = Shopify.session() |> InventoryItem.update(1, update)
    assert "Update" == response.data.sku
  end
end
