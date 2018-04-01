defmodule Shopify.CheckoutTest do
  use ExUnit.Case, async: true

  alias Shopify.Checkout

  test "client can request all checkouts" do
    assert {:ok, response} = Shopify.session() |> Checkout.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/checkouts.json", "checkouts", [Checkout.empty_resource()])

    assert fixture == response.data
  end

  test "client can request a checkouts count" do
    assert {:ok, response} = Shopify.session() |> Checkout.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/checkouts/count.json", "count", nil)
    assert fixture == response.data
  end
end
