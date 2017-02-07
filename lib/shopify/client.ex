defmodule Shopify.Client do
  @moduledoc false

  @adapter Shopify.Config.get(:client_adapter) || Shopify.Adapters.HTTP

  def get(request), do: @adapter.get(request)

  def post(request), do: @adapter.post(request)

  def put(request), do: @adapter.put(request)

  def delete(request), do: @adapter.delete(request)
end
