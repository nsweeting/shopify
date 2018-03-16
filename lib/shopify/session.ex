defmodule Shopify.Session do
  @moduledoc false

  alias Shopify.Config

  defstruct [
    :type,
    :shop_name,
    :api_key,
    :password,
    :access_token,
    :client_id,
    :client_secret
  ]

  @spec new(binary, binary, binary) :: %Shopify.Session{}
  def new(shop_name, api_key, password) do
    %Shopify.Session{
      type: :basic,
      shop_name: Shopify.scrub_shop_name(shop_name),
      api_key: api_key,
      password: password
    }
  end

  @spec new(binary, binary) :: %Shopify.Session{}
  def new(shop_name, access_token) do
    %Shopify.Session{
      type: :oauth,
      shop_name: Shopify.scrub_shop_name(shop_name),
      access_token: access_token
    }
  end

  @spec new(binary) :: %Shopify.Session{}
  def new(shop_name) do
    %Shopify.Session{
      type: :oauth,
      shop_name: Shopify.scrub_shop_name(shop_name),
      client_id: Config.get(:client_id),
      client_secret: Config.get(:client_secret)
    }
  end

  @spec new :: %Shopify.Session{}
  def new do
    new(Shopify.scrub_shop_name(Config.shop_name()), Config.api_key(), Config.password())
  end
end
