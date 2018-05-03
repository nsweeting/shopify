defmodule Shopify.InventoryLevelTest do
  use ExUnit.Case, async: true

  alias Shopify.InventoryLevel
  test "client can request all inventory_levels" do
    params = %{inventory_item_ids: [808950810, 39072856], location_ids: [905684977, 487838322]}
    assert {:ok, response} = Shopify.session() |> InventoryLevel.all(params)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/inventory_levels.json", "inventory_levels", [InventoryLevel.empty_resource()])
    assert fixture == response.data
  end

  test "client responds with error 422 if no location_ids or inventory_item_ids parameter" do
    {success, %{code: code}} = Shopify.session() |> InventoryLevel.all()

    assert success == :error
    assert code == 422
  end

  test "client can request to delete an inventory_level" do
    assert {:ok, response} = Shopify.session() |> InventoryLevel.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
