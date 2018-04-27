defmodule Shopify.Product.EventTest do
  use ExUnit.Case, async: true

  alias Shopify.Product.Event

  test "client can request all events" do
    assert {:ok, response} = Shopify.session() |> Event.all(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/products/1/events.json", "events", [Event.empty_resource()])

    assert fixture == response.data
  end
end
