defmodule Shopify.Client do
  @moduledoc false

  alias Shopify.Config

  def get(request), do: Config.client_adapter.get(request)

  def post(request), do: Config.client_adapter.post(request)

  def put(request), do: Config.client_adapter.put(request)

  def delete(request), do: Config.client_adapter.delete(request)
end
