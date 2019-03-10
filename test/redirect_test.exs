defmodule Shopify.RedirectTest do
  use ExUnit.Case, async: true

  alias Shopify.Redirect

  test "client can request a single redirect" do
    assert {:ok, response} = Shopify.session() |> Redirect.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/redirects/1.json", "redirect", Redirect.empty_resource())

    assert fixture == response.data
  end

  test "client can request all redirects" do
    assert {:ok, response} = Shopify.session() |> Redirect.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/redirects.json", "redirects", [Redirect.empty_resource()])

    assert fixture == response.data
  end

  test "client can request a nredirect count" do
    assert {:ok, response} = Shopify.session() |> Redirect.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/redirects/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create an redirect" do
    fixture =
      Fixture.load("../test/fixtures/redirects/1.json", "redirect", Redirect.empty_resource())

    assert {:ok, response} = Shopify.session() |> Redirect.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/redirects/1.json", "redirect", Redirect.empty_resource())

    assert fixture == response.data
  end

  test "client can request to update an redirect" do
    assert {:ok, response} = Shopify.session() |> Redirect.find(1)
    assert "/leopard" == response.data.path
    update = %{response.data | path: "Update"}
    assert {:ok, response} = Shopify.session() |> Redirect.update(1, update)
    assert "Update" == response.data.path
  end

  test "client can request to patch update an redirect" do
    update = %{path: "Update"}
    assert {:ok, response} = Shopify.session() |> Redirect.patch_update(1, update)
    assert "Update" == response.data.path
  end

  test "client can request to delete an redirect" do
    assert {:ok, response} = Shopify.session() |> Redirect.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
