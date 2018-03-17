defmodule Shopify.Config do
  @moduledoc false

  def get(name, default \\ nil) do
    Application.get_env(:shopify, name, default)
  end

  def client_adapter, do: get(:client_adapter, Shopify.Adapters.HTTP)

  def shop_name, do: get(:shop_name)

  def api_key, do: get(:api_key)

  def password, do: get(:password)

  def version, do: Mix.Project.config()[:version]

  def fixtures_path do
    get(:fixtures_path) || Path.expand("../../test/fixtures/", __DIR__)
  end
end
