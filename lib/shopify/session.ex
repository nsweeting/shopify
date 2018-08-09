defmodule Shopify.Session do
  @moduledoc false

  alias Shopify.{Config, Session}

  defstruct [
    :type,
    :shop_name,
    :api_key,
    :password,
    :access_token,
    :client_id,
    :client_secret,
    :req_opts
  ]

  @type t :: %__MODULE__{
          type: :basic | :oauth,
          shop_name: binary,
          api_key: binary | nil,
          password: binary | nil,
          access_token: binary | nil,
          client_id: binary | nil,
          req_opts: Keyword.t() | nil
        }

  @spec new(binary, binary, binary) :: Shopify.Session.t()
  def new(shop_name, api_key, password) do
    %Session{
      type: :basic,
      shop_name: Shopify.scrub_shop_name(shop_name),
      api_key: api_key,
      password: password
    }
  end

  @spec new(binary, binary) :: Shopify.Session.t()
  def new(shop_name, access_token) do
    %Session{
      type: :oauth,
      shop_name: Shopify.scrub_shop_name(shop_name),
      access_token: access_token
    }
  end

  @spec new(binary) :: Shopify.Session.t()
  def new(shop_name) do
    %Session{
      type: :oauth,
      shop_name: Shopify.scrub_shop_name(shop_name),
      client_id: Config.get(:client_id),
      client_secret: Config.get(:client_secret)
    }
  end

  @spec new() :: Shopify.Session.t()
  def new do
    new(Shopify.scrub_shop_name(Config.shop_name()), Config.api_key(), Config.password())
  end

  @spec put_req_opt(session :: Shopify.Session.t(), atom, any) :: Shopify.Session.t()
  def put_req_opt(%Session{} = session, key, value) do
    %{session | req_opts: [{key, value} | session.req_opts || []]}
  end

  @spec put_req_opts(session :: Shopify.Session.t(), req_opts :: Shopify.Request.options()) ::
          Shopify.Session.t()
  def put_req_opts(%Session{} = session, req_opts) when is_list(req_opts) do
    %{session | req_opts: req_opts}
  end
end
