defmodule Shopify.Country.ProvinceTest do
  use ExUnit.Case, async: true

  alias Shopify.Country.Province

  test "client can request a single province" do
    assert {:ok, response} = Shopify.session() |> Province.find(1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/countries/1/provinces/1.json",
        "province",
        Province.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request all countries/1/provinces" do
    assert {:ok, response} = Shopify.session() |> Province.all(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/countries/1/provinces.json", "provinces", [
        Province.empty_resource()
      ])

    assert fixture == response.data
  end

  test "client can request a province count" do
    assert {:ok, response} = Shopify.session() |> Province.count(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/countries/1/provinces/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to update an province" do
    assert {:ok, response} = Shopify.session() |> Province.find(1, 1)
    assert "QC" == response.data.code
    update = %{response.data | code: "Update"}
    assert {:ok, response} = Shopify.session() |> Province.update(1, 1, update)
    assert "Update" == response.data.code
  end
end
