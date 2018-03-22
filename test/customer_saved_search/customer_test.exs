defmodule Shopify.CustomerSavedSearch.CustomerTest do
  use ExUnit.Case, async: true

  alias Shopify.CustomerSavedSearch.Customer

  test "client can request all orders" do
    assert {:ok, response} = Shopify.session() |> Customer.all(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/customer_saved_searches/1/customers.json", "customers", [
        Customer.empty_resource()
      ])

    assert fixture == response.data
  end
end
