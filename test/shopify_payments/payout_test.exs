defmodule Shopify.ShopifyPayments.PayoutTest do
  use ExUnit.Case, async: true

  alias Shopify.ShopifyPayments.Payout

  test "client can request a single payout" do
    assert {:ok, response} = Shopify.session() |> Payout.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/shopify_payments/payouts/1.json",
        "payout",
        Payout.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request all payouts" do
    assert {:ok, response} = Shopify.session() |> Payout.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/shopify_payments/payouts.json", "payouts", [
        Payout.empty_resource()
      ])

    assert fixture == response.data
  end
end
