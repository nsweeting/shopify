defmodule Shopify.Config do
  @doc """
  Retrieves a key value from the configuration.
  """
  def get(name, default \\ nil) do
    Application.get_env(:shopify, name, default)
  end

  def basic_auth do
    {get(:shop_name), get(:api_key), get(:password)}
  end
end