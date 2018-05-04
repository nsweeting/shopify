defmodule Shopify.InventoryLevelTest do
  use ExUnit.Case, async: true

  alias Shopify.InventoryLevel

  test "client can request all inventory_levels" do
    params = %{
      inventory_item_ids: [808_950_810, 39_072_856],
      location_ids: [905_684_977, 487_838_322]
    }

    assert {:ok, response} = Shopify.session() |> InventoryLevel.all(params)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/inventory_levels.json", "inventory_levels", [
        InventoryLevel.empty_resource()
      ])

    assert fixture == response.data
  end

  test "client responds with error 422 if no location_ids or inventory_item_ids parameter for all/2" do
    {success, %{code: code}} = Shopify.session() |> InventoryLevel.all(%{something_else: "asdf"})

    assert success == :error
    assert code == 422
  end

  test "client can request to delete an inventory_level" do
    assert {:ok, response} = Shopify.session() |> InventoryLevel.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end

  test "client can request an adjustment" do
    params = %{inventory_item_id: 123, location_id: 123, available_adjustment: 123}

    assert {:ok, resp} = Shopify.session() |> InventoryLevel.adjust(params)

    fixture =
      Fixture.load(
        "../test/fixtures/inventory_levels/adjust.json",
        "inventory_level",
        InventoryLevel.empty_resource()
      )

    assert resp.code == 200
    assert resp.data == fixture
  end

  test "client responds with error 422 if parameters missing for adjust/2" do
    params = %{inventory_item_id: 123, location_id: 123}

    {success, resp} = Shopify.session() |> InventoryLevel.adjust(params)

    assert success == :error
    assert resp.code == 422
  end

  test "client can request to connect inventory to a location" do
    params = %{inventory_item_id: 123, location_id: 123}

    assert {:ok, resp} = Shopify.session() |> InventoryLevel.connect(params)

    fixture =
      Fixture.load(
        "../test/fixtures/inventory_levels/connect.json",
        "inventory_level",
        InventoryLevel.empty_resource()
      )

    assert resp.code == 200
    assert resp.data == fixture
  end

  test "client responds with error 422 if parameters missing for connect/2" do
    params = %{inventory_item_id: 123}

    {success, resp} = Shopify.session() |> InventoryLevel.connect(params)

    assert success == :error
    assert resp.code == 422
  end

  test "client can request to set available inventory at a location" do
    params = %{inventory_item_id: 123, location_id: 123, available: 5}

    assert {:ok, resp} = Shopify.session() |> InventoryLevel.set(params)

    fixture =
      Fixture.load(
        "../test/fixtures/inventory_levels/set.json",
        "inventory_level",
        InventoryLevel.empty_resource()
      )

    assert resp.code == 200
    assert resp.data == fixture
  end

  test "client responds with error 422 if parameters missing for set/2" do
    params = %{inventory_item_id: 123}

    {success, resp} = Shopify.session() |> InventoryLevel.set(params)

    assert success == :error
    assert resp.code == 422
  end
end
