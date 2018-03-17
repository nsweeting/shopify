defmodule Shopify.Adapters.Mocktest do
  use ExUnit.Case, async: true

  alias Shopify.{Webhook, Request, Adapters.Mock}

  test "it puts an id for created resources" do
    body = "{\"webhook\": {\"address\": \"http://www.yoloship.it/webhook\"}}"

    {:ok, %{data: resource}} =
      Shopify.session()
      |> Request.new(Webhook.all_url(), %{}, Webhook.singular_resource(), body)
      |> Mock.post()

    assert resource.id != nil
  end
end
