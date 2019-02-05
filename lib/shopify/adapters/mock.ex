defmodule Shopify.Adapters.Mock do
  @moduledoc false

  @behaviour Shopify.Adapters.Base

  alias Shopify.{
    Request,
    Response,
    Config,
    Adapters.MockUtils
  }

  def get(%Shopify.Request{query_params: query_params} = request) when not is_nil(query_params) do
    request
    |> authorize
    |> respond
    |> MockUtils.filter_resources(request)
  end

  def get(request) do
    request
    |> authorize
    |> respond
  end

  def post(request) do
    request
    |> authorize
    |> respond
  end

  def put(request) do
    request
    |> authorize
    |> respond
  end

  def delete(request) do
    auth = request |> authorize

    case auth do
      {:passed, _} -> Response.new(200, nil, request.resource)
      {:failed, _} -> respond(auth)
    end
  end

  def respond({:failed, request}) do
    Response.new(401, nil, request.resource)
  end

  def respond({:passed, request}) do
    request
    |> load_resource
    |> respond(request)
  end

  def respond({:ok, body}, request) do
    Response.new(200, body, request.resource)
  end

  def respond({:error, _}, request) do
    Response.new(404, nil, request.resource)
  end

  def load_resource(%Request{path: path, body: nil}) do
    (Config.fixtures_path() <> "/" <> path)
    |> File.read()
  end

  def load_resource(%Request{body: body}) do
    case Poison.decode(body) do
      {:ok, resource} -> resource |> MockUtils.put_id() |> Poison.encode()
      {:error, _} -> {:error, nil}
    end
  end

  def authorize(request) do
    if request.headers[:"X-Shopify-Access-Token"] do
      request |> oauth_auth
    else
      request |> basic_auth
    end
  end

  def basic_auth(request) do
    case URI.parse(request.full_url) do
      %URI{userinfo: "test:test"} -> {:passed, request}
      %URI{userinfo: _} -> {:failed, request}
    end
  end

  def oauth_auth(request) do
    case request.headers[:"X-Shopify-Access-Token"] do
      "test" -> {:passed, request}
      _ -> {:failed, request}
    end
  end
end
