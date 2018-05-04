defmodule Shopify.RiskTest do
  use ExUnit.Case, async: true

  alias Shopify.Order

  test "client can request a single risk" do
    assert {:ok, response} = Shopify.session() |> Order.Risk.find(1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/orders/1/risks/1.json", "risk", Order.Risk.empty_resource())

    assert fixture == response.data
  end

  test "client can request all risks" do
    assert {:ok, response} = Shopify.session() |> Order.Risk.all(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/orders/1/risks.json", "risks", [Order.Risk.empty_resource()])

    assert fixture == response.data
  end

  test "client can request to create an risk" do
    fixture =
      Fixture.load("../test/fixtures/orders/1/risks/1.json", "risk", Order.Risk.empty_resource())

    assert {:ok, response} = Shopify.session() |> Order.Risk.create(1, fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/orders/1/risks/1.json", "risk", Order.Risk.empty_resource())

    assert fixture == response.data
  end

  test "client can request to update an risk" do
    assert {:ok, response} = Shopify.session() |> Order.Risk.find(1, 1)
    assert "This order came from an anonymous proxy" == response.data.message
    update = %{response.data | message: "Update"}
    assert {:ok, response} = Shopify.session() |> Order.Risk.update(1, 1, update)
    assert "Update" == response.data.message
  end

  test "client can request to delete an risk" do
    assert {:ok, response} = Shopify.session() |> Order.Risk.delete(1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
