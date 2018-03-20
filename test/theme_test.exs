defmodule Shopify.ThemeTest do
  use ExUnit.Case, async: true

  alias Shopify.Theme

  test "client can request a single theme" do
    assert {:ok, response} = Shopify.session() |> Theme.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/themes/1.json", "theme", Theme.empty_resource())
    assert fixture == response.data
  end

  test "client can request all themes" do
    assert {:ok, response} = Shopify.session() |> Theme.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/themes.json", "themes", [Theme.empty_resource()])
    assert fixture == response.data
  end

  test "client can request to create a theme" do
    fixture = Fixture.load("../test/fixtures/themes/1.json", "theme", Theme.empty_resource())
    assert {:ok, response} = Shopify.session() |> Theme.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/themes/1.json", "theme", Theme.empty_resource())
    assert fixture == response.data
  end

  test "client can request to update an theme" do
    assert {:ok, response} = Shopify.session() |> Theme.find(1)
    assert "Comfort" == response.data.name
    update = %{response.data | name: "Update"}
    assert {:ok, response} = Shopify.session() |> Theme.update(1, update)
    assert "Update" == response.data.name
  end

  test "client can request to delete an theme" do
    assert {:ok, response} = Shopify.session() |> Theme.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
