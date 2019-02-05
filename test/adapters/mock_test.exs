defmodule Shopify.Adapters.Mocktest do
  use ExUnit.Case, async: true

  alias Shopify.{
    Webhook,
    Product,
    Request,
    Adapters.Mock
  }

  test "it puts an id for created resources" do
    body = "{\"webhook\": {\"address\": \"http://www.yoloship.it/webhook\"}}"

    {:ok, %{data: resource}} =
      Shopify.session()
      |> Request.new(Webhook.all_url(), %{}, Webhook.singular_resource(), body)
      |> Mock.post()

    assert resource.id != nil
  end

  test "it filters resources when given query params" do
    body =
      "{\"products\": [{\"product_type\": \"Some Product\"},{\"product_type\": \"Some Other Product\"}]}"

    {:ok, %{data: resource}} =
      Shopify.session()
      |> Request.new(
        Product.all_url(),
        %{product_type: "Some Product"},
        Product.plural_resource(),
        body
      )
      |> Mock.get()

    assert length(resource) == 1
  end

  test "it can use oauth when token is \"test\"" do
    assert {:ok, _} =
             Shopify.session("shop-name.myshopify.com", "test")
             |> Shopify.Product.all()
  end

  test "it fails authentication when oauth token is anything other than \"test\"" do
    assert {:error, _} =
             Shopify.session("shop-name.myshopify.com", "fail")
             |> Shopify.Product.all()
  end
end
