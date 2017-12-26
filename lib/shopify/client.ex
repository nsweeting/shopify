defmodule Shopify.Client do
  @moduledoc false

  def get(request), do: Application.get_env(:shopify, :client_adapter, Shopify.Adapters.HTTP).get(request)

  def post(request), do: Application.get_env(:shopify, :client_adapter, Shopify.Adapters.HTTP).post(request)

  def put(request), do: Application.get_env(:shopify, :client_adapter, Shopify.Adapters.HTTP).put(request)

  def delete(request), do: Application.get_env(:shopify, :client_adapter, Shopify.Adapters.HTTP).delete(request)
end
