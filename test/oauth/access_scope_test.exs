defmodule Shopify.OAuth.AccessScopeTest do
  use ExUnit.Case, async: true

  alias Shopify.OAuth.AccessScope

  test "client can request all checkouts" do
    assert {:ok, response} = Shopify.session() |> AccessScope.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/oauth/access_scopes.json", "access_scopes", [
        AccessScope.empty_resource()
      ])

    assert fixture == response.data
  end
end
