defmodule Shopify.RequestTest do
  use ExUnit.Case, async: true

  test "will build full_url using session api_version if present" do
    request =
      Shopify.session()
      |> Shopify.Session.put_api_version("foo")
      |> Shopify.Request.new("bar", %{}, nil)

    assert request.full_url == "https://test:test@test.myshopify.com/admin/api/foo/bar"

    request =
      Shopify.session()
      |> Shopify.Request.new("bar", %{}, nil)

    assert request.full_url == "https://test:test@test.myshopify.com/admin/bar"
  end
end
