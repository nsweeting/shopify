defmodule Shopify.PriceRuleTest do
  use ExUnit.Case, async: true

  alias Shopify.PriceRule

  test "client can request all price rules" do
    assert {:ok, response} = Shopify.session() |> PriceRule.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/price_rules.json", "price_rules", [
        PriceRule.empty_resource()
      ])

    assert fixture == response.data
  end

  test "client can request a single price rule" do
    assert {:ok, response} = Shopify.session() |> PriceRule.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/price_rules/1.json",
        "price_rule",
        PriceRule.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request to create a price_rule" do
    fixture =
      Fixture.load(
        "../test/fixtures/price_rules/1.json",
        "price_rule",
        PriceRule.empty_resource()
      )

    assert {:ok, response} = Shopify.session() |> PriceRule.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/price_rules/1.json",
        "price_rule",
        PriceRule.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request to update a price_rule" do
    assert {:ok, response} = Shopify.session() |> PriceRule.find(1)
    assert "74NSJ3SK08M0" == response.data.title
    update = %{response.data | title: "Blehp"}
    assert {:ok, response} = Shopify.session() |> PriceRule.update(1, update)
    assert "Blehp" == response.data.title
  end

  test "client can request to delete a price rule" do
    assert {:ok, response} = Shopify.session() |> PriceRule.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
