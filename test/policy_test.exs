defmodule Shopify.PolicyTest do
  use ExUnit.Case, async: true

  alias Shopify.Policy

  test "client can request all policies" do
    assert {:ok, response} = Shopify.session() |> Policy.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/policies.json", "policies", [Policy.empty_resource()])

    assert fixture == response.data
  end
end
