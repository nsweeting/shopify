defmodule Shopify.CommentTest do
  use ExUnit.Case, async: true

  alias Shopify.Comment

  test "client can request a single comment" do
    assert {:ok, response} = Shopify.session() |> Comment.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/comments/1.json", "comment", Comment.empty_resource())

    assert fixture == response.data
  end

  test "client can request all comments" do
    assert {:ok, response} = Shopify.session() |> Comment.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/comments.json", "comments", [Comment.empty_resource()])

    assert fixture == response.data
  end

  test "client can request a comment count" do
    assert {:ok, response} = Shopify.session() |> Comment.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/comments/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create a comment" do
    fixture =
      Fixture.load("../test/fixtures/comments/1.json", "comment", Comment.empty_resource())

    assert {:ok, response} = Shopify.session() |> Comment.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/comments/1.json", "comment", Comment.empty_resource())

    assert fixture == response.data
  end

  test "client can request to update a comment" do
    assert {:ok, response} = Shopify.session() |> Comment.find(1)
    assert "Soleone" == response.data.author
    update = %{response.data | author: "Update"}
    assert {:ok, response} = Shopify.session() |> Comment.update(1, update)
    assert "Update" == response.data.author
  end

  test "client can request to patch update a comment" do
    update = %{author: "Update"}
    assert {:ok, response} = Shopify.session() |> Comment.patch_update(1, update)
    assert "Update" == response.data.author
  end

  test "client can mark a comment as spam" do
    assert {:ok, response} = Shopify.session() |> Comment.spam(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/comments/1/spam.json", Comment.empty_resource())
    assert fixture == response.data
  end

  test "client can mark a comment as not spam" do
    assert {:ok, response} = Shopify.session() |> Comment.not_spam(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/comments/1/not_spam.json", Comment.empty_resource())
    assert fixture == response.data
  end

  test "client can approve a comment" do
    assert {:ok, response} = Shopify.session() |> Comment.approve(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/comments/1/approve.json", Comment.empty_resource())
    assert fixture == response.data
  end

  test "client can remove a comment" do
    assert {:ok, response} = Shopify.session() |> Comment.remove(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/comments/1/remove.json", Comment.empty_resource())
    assert fixture == response.data
  end

  test "client can restore a comment" do
    assert {:ok, response} = Shopify.session() |> Comment.restore(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/comments/1/restore.json", Comment.empty_resource())
    assert fixture == response.data
  end
end
