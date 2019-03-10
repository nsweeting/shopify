defmodule Shopify.CheckoutTest do
  use ExUnit.Case, async: true

  alias Shopify.Checkout

  test "client can request a single checkout" do
    assert {:ok, response} =
             Shopify.session() |> Checkout.find("exuw7apwoycchjuwtiqg8nytfhphr62a")

    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/checkouts/exuw7apwoycchjuwtiqg8nytfhphr62a.json",
        "checkout",
        Checkout.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request all checkouts" do
    assert {:ok, response} = Shopify.session() |> Checkout.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/checkouts.json", "checkouts", [Checkout.empty_resource()])

    assert fixture == response.data
  end

  test "client can request to create a checkout" do
    fixture =
      Fixture.load(
        "../test/fixtures/checkouts/exuw7apwoycchjuwtiqg8nytfhphr62a.json",
        "checkout",
        Checkout.empty_resource()
      )

    assert {:ok, response} = Shopify.session() |> Checkout.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    assert fixture == response.data
  end

  test "client can request to update a checkout" do
    assert {:ok, response} =
             Shopify.session() |> Checkout.find("exuw7apwoycchjuwtiqg8nytfhphr62a")

    assert 207_119_551 == response.data.customer_id
    update = %{response.data | customer_id: 123}

    assert {:ok, response} =
             Shopify.session() |> Checkout.update("exuw7apwoycchjuwtiqg8nytfhphr62a", update)

    assert 123 == response.data.customer_id
  end

  test "client can request to patch update a product" do
    update = %{customer_id: 123}

    assert {:ok, response} =
             Shopify.session()
             |> Checkout.patch_update("exuw7apwoycchjuwtiqg8nytfhphr62a", update)

    assert 123 == response.data.customer_id
  end

  test "client can request to complete a checkout without payment" do
    assert {:ok, response} =
             Shopify.session() |> Checkout.complete("exuw7apwoycchjuwtiqg8nytfhphr62a")

    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/checkouts/exuw7apwoycchjuwtiqg8nytfhphr62a/complete.json",
        Checkout.empty_resource()
      )

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
