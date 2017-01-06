defmodule Shopify.Config do
  @doc """
  Retrieves a key value from the configuration.
  """
  def get(name, default \\ nil) do
    Application.get_env(:shopify, name, default)
  end

  def pool_name, do: get(:pool_name, :"Shopify.Pool")

  def timeout, do: get(:timeout, 10000000)

  def basic_auth do
    {get(:shop_name), get(:api_key), get(:password)}
  end
end