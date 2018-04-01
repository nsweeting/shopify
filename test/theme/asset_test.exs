defmodule Shopify.Theme.AssetTest do
  use ExUnit.Case, async: true

  alias Shopify.Theme

  test "client can request a single asset by providing the asset name instead of an id" do
    assert {:ok, response} = Shopify.session() |> Theme.Asset.find(1, "test_asset")
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/themes/1/assets.json?asset[key]=test_asset",
        "asset",
        Theme.Asset.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request all assets" do
    assert {:ok, response} = Shopify.session() |> Theme.Asset.all(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/themes/1/assets.json", "assets", [
        Theme.Asset.empty_resource()
      ])

    assert fixture == response.data
  end

  test "client can request to delete an asset by providing the asset name instead of an id" do
    assert {:ok, response} = Shopify.session() |> Theme.Asset.delete(1, "templates/index.liquid")
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
