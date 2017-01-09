defmodule Shopify.Config do
  @doc """
  Retrieves a key value from the configuration.

    iex> Shopify.Config.get(:shop_name)
    "my-shop-name"
  """
  def get(name, default \\ nil) do
    Application.get_env(:shopify, name, default)
  end

  @doc """
  Retrieves a three-element tuple for basic auth using Application config.

  Returns {shop_name, api_key, password}

  ## Examples

    iex> Shopify.Config.basic_auth
    {"my-shop-name", "my-api-key", "my-password"}
  """

  def basic_auth do
    {get(:shop_name), get(:api_key), get(:password)}
  end
end