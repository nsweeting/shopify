defmodule Shopify.WebhookTest do
  use ExUnit.Case, async: true

  alias Shopify.Webhook

  test "client can request a single webhook" do
    assert {:ok, response} = Shopify.session() |> Webhook.find(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/webhooks/1.json", "webhook", Webhook.empty_resource())

    assert fixture == response.data
  end

  test "client can request all webhooks" do
    assert {:ok, response} = Shopify.session() |> Webhook.all()
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/webhooks.json", "webhooks", [Webhook.empty_resource()])

    assert fixture == response.data
  end

  test "client can request a webhook count" do
    assert {:ok, response} = Shopify.session() |> Webhook.count()
    assert %Shopify.Response{} = response
    assert 200 == response.code
    fixture = Fixture.load("../test/fixtures/webhooks/count.json", "count", nil)
    assert fixture == response.data
  end

  test "client can request to create a webhook" do
    fixture =
      Fixture.load("../test/fixtures/webhooks/1.json", "webhook", Webhook.empty_resource())

    assert {:ok, response} = Shopify.session() |> Webhook.create(fixture)
    assert %Shopify.Response{} = response
    assert 200 == response.code

    fixture =
      Fixture.load("../test/fixtures/webhooks/1.json", "webhook", Webhook.empty_resource())

    assert fixture == response.data
  end

  test "client can request to update a webhook" do
    assert {:ok, response} = Shopify.session() |> Webhook.find(1)
    assert "orders/create" == response.data.topic
    update = %{response.data | topic: "Update"}
    assert {:ok, response} = Shopify.session() |> Webhook.update(1, update)
    assert "Update" == response.data.topic
  end

  test "client can request to delete a webhook" do
    assert {:ok, response} = Shopify.session() |> Webhook.delete(1)
    assert %Shopify.Response{} = response
    assert 200 == response.code
    assert nil == response.data
  end

  test "authorized webhooks will return true" do
    body = ~s({"foo": "bar"})

    hmac =
      :crypto.mac(:hmac, :sha256, Shopify.Config.get(:client_secret), body) |> Base.encode64()

    assert Webhook.authenticate(hmac, body)
  end

  test "unauthorized webhooks will return false" do
    body = ~s({"foo": "bar"})

    hmac =
      :crypto.mac(:hmac, :sha256, Shopify.Config.get(:client_secret), body) |> Base.encode64()

    refute Webhook.authenticate(hmac, ~s({"foo": "baz"}))
  end
end
