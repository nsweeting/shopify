defmodule Shopify do
  @doc """
  Create a new Shopify session for a private app using the provided config.

  Returns `%Shopify.Session{}`

  ## Examples

      iex> Shopify.session("my-shop-name", "my-api-key", "my-password")
      %Shopify.Session{access_token: nil, api_key: "my-api-key", base_url: "https://my-api-key:my-password@my-shop-name.myshopify.com/admin/", client_id: nil,
      client_secret: nil, headers: ["Content-Type": "application/json"], password: "my-password", shop_name: "my-shop-name", type: :basic}
  """
  def session(shop_name, api_key, password) do
    Shopify.Session.new(shop_name, api_key, password)
  end

  @doc """
  Create a new Shopify session for an OAuth app using the provided config.

  Returns `%Shopify.Session{}`

  ## Examples
      iex> Shopify.session("shop-name", "access-token")
      %Shopify.Session{access_token: "access-token", api_key: nil, base_url: "https://test-store.myshopify.com/admin/", client_id: nil,
      client_secret: nil, headers: ["X-Shopify-Access-Token": "access-token", "Content-Type": "application/json"], password: nil,
      shop_name: "test-store", type: :oauth}
  """
  def session(shop_name, access_token) do
    Shopify.Session.new(shop_name, access_token)
  end

  @doc """
  Create a new Shopify session for an OAuth app using the provided shop name. This will include your Application.config client_id
  and client_secret in the session. This should only be used when attempting to generate new access tokens.

  Returns `%Shopify.Session{}`

  ## Examples

      iex> Shopify.session
      %Shopify.Session{access_token: nil, api_key: nil, base_url: "https://shop-name.myshopify.com/admin/", client_id: "my-client-id",
      client_secret: "my-client-secret", headers: ["Content-Type": "application/json"], password: nil, shop_name: "shop-name", type: :oauth}
  """
  def session(shop_name), do: Shopify.Session.new(shop_name)

  @doc """
  Create a new Shopify session for a private app using Application config.

  Returns %Shopify.Session{}

  ## Examples

      iex> Shopify.session
      %Shopify.Session{access_token: nil, api_key: "my-api-key", base_url: "https://my-api-key:my-password@my-shop-name.myshopify.com/admin/", client_id: nil,
      client_secret: nil, headers: ["Content-Type": "application/json"], password: "my-password", shop_name: "my-shop-name", type: :basic}
  """
  def session, do: Shopify.Session.new
end