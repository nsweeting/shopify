defmodule Shopify do
  @doc """
  Create a new Shopify session of a provided type and config.

  Returns %Shopify.Session{}

  ## Examples

      iex> Shopify.session(:oauth, {"my-shop-name", "my-access-token")
      %Shopify.Session{access_token: "my-access-token", api_key: nil, base_url: "https://my-test-store.myshopify.com/admin/", client_id: nil,
      client_secret: nil, headers: ["X-Shopify-Access-Token": "my-access-token", "Content-Type": "application/json"], password: nil,
      shop_name: "my-test-store", type: :oauth}
  """
  def session(type, config), do: Shopify.Session.new(type, config)

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