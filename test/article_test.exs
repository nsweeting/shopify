defmodule Shopify.ArticleTest do
  use ExUnit.Case, async: true

  alias Shopify.Article

  test "client can request a single article" do
    assert {:ok, response} = Shopify.session() |> Article.find(1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/blogs/1/articles/1.json",
        "article",
        Article.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request all articles" do
    assert {:ok, response} = Shopify.session() |> Article.all(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/blogs/1/articles.json", "articles", [
        Article.empty_resource()
      ])

    assert fixture == response.data
  end

  test "client can request a article count" do
    assert {:ok, response} = Shopify.session() |> Article.count(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/blogs/1/articles/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create an article" do
    fixture =
      Fixture.load(
        "../test/fixtures/blogs/1/articles/1.json",
        "article",
        Article.empty_resource()
      )

    assert {:ok, response} = Shopify.session() |> Article.create(1, fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load(
        "../test/fixtures/blogs/1/articles/1.json",
        "article",
        Article.empty_resource()
      )

    assert fixture == response.data
  end

  test "client can request to update an article" do
    assert {:ok, response} = Shopify.session() |> Article.find(1, 1)
    assert "Others have awesome stuff, too!" == response.data.title
    update = %{response.data | title: "Update"}
    assert {:ok, response} = Shopify.session() |> Article.update(1, 1, update)
    assert "Update" == response.data.title
  end

  test "client can request to delete an article" do
    assert {:ok, response} = Shopify.session() |> Article.delete(1, 1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end
end
