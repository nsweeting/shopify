defmodule Shopify.PriceRule.DiscountCodeTest do
  use ExUnit.Case, async: true

  alias Shopify.{
    PriceRule.DiscountCode,
    PriceRule
  }

  @fixtures_path "../test/fixtures/price_rules/1/"

  test "client can request all price rules" do
    assert {:ok, response} = Shopify.session() |> DiscountCode.all(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(@fixtures_path <> "discount_codes.json", "discount_codes", [
        DiscountCode.empty_resource()
      ])

    assert fixture == response.data
  end

  test "client can request a single price rule" do
    assert {:ok, response} = Shopify.session() |> DiscountCode.find(1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        @fixtures_path <> "discount_codes/1.json",
        "discount_code",
        DiscountCode.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request to create a price_rule" do
    fixture =
      Fixture.load(
        @fixtures_path <> "discount_codes/1.json",
        "discount_code",
        DiscountCode.empty_resource()
      )

    assert {:ok, response} = Shopify.session() |> DiscountCode.create(1, fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        @fixtures_path <> "discount_codes/1.json",
        "discount_code",
        DiscountCode.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request to update a price_rule" do
    assert {:ok, response} = Shopify.session() |> DiscountCode.find(1, 1)
    assert "MySecondCode" == response.data.code
    update = %{response.data | code: "123Code"}
    assert {:ok, response} = Shopify.session() |> DiscountCode.update(1, 1, update)
    assert "123Code" == response.data.code
  end

  test "client can request to delete a price rule" do
    assert {:ok, response} = Shopify.session() |> DiscountCode.delete(1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
