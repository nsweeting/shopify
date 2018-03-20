defmodule Shopify.Article.AuthorTest do
  use ExUnit.Case, async: true

  alias Shopify.Article

  test "client can request all article authors" do
    assert {:ok, response} = Shopify.session() |> Article.Author.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/articles/authors.json", "authors", [
        Article.Author.empty_resource()
      ])

    assert fixture == response.data
  end

  test "client can request all article tags" do
    assert {:ok, response} = Shopify.session() |> Article.Tag.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/articles/tags.json", "tags", [
        Article.Tag.empty_resource()
      ])

    assert fixture == response.data
  end
end
