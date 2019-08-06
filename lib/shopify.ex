defmodule Shopify do
  @doc """
  Removes .myshopify.com (returned by queries to shopify) from shop names

  ## Examples

      iex> Shopify.scrub_shop_name("shop-name.myshopify.com")
      "shop-name"

      iex> Shopify.scrub_shop_name("shop-name")
      "shop-name"
  """
  def scrub_shop_name(name) when is_binary(name) do
    String.replace(name, ".myshopify.com", "")
  end

  def scrub_shop_name(_) do
    nil
  end

  @doc """
  Create a new Shopify session for a private app using the provided config.

  Returns `%Shopify.Session{}`

  ## Examples

      iex> Shopify.session("my-shop-name", "my-api-key", "my-password")
      %Shopify.Session{
        access_token: nil,
        api_key: "my-api-key",
        api_version: nil,
        client_id: nil,
        client_secret: nil,
        password: "my-password",
        shop_name: "my-shop-name",
        type: :basic
      }
  """
  def session(shop_name, api_key, password) do
    Shopify.Session.new(shop_name, api_key, password)
  end

  @doc """
  Create a new Shopify session for an OAuth app using the provided config.

  Returns `%Shopify.Session{}`

  ## Examples
      iex> Shopify.session("shop-name", "access-token")
      %Shopify.Session{
        access_token: "access-token",
        api_key: nil,
        api_version: nil,
        client_id: nil,
        client_secret: nil,
        password: nil,
        shop_name: "shop-name",
        type: :oauth
      }
  """
  def session(shop_name, access_token) do
    Shopify.Session.new(shop_name, access_token)
  end

  @doc """
  Create a new Shopify session for an OAuth app using the provided shop name. This will include your Application.config client_id
  and client_secret in the session. This should only be used when attempting to generate new access tokens.

  Returns `%Shopify.Session{}`

  ## Examples

      iex> with %Shopify.Session{shop_name: "shop_name"} <- Shopify.session("shop_name"), do: :passed
      :passed
  """
  def session(shop_name) do
    Shopify.Session.new(shop_name)
  end

  @doc """
  Create a new Shopify session for a private app using Application config.

  Returns %Shopify.Session{}

  ## Examples

      iex> with %Shopify.Session{} <- Shopify.session, do: :passed
      :passed
  """
  def session do
    Shopify.Session.new()
  end
end
