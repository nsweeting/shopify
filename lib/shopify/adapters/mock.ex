defmodule Shopify.Adapters.Mock do
  @moduledoc false

  @behaviour Shopify.Adapters.Base

  alias Shopify.{
    Request,
    Response,
    Config
  }

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
      {:ok, resource} -> resource |> put_id |> Poison.encode()
      {:error, _} -> {:error, nil}
    end
  end

  defp put_id(raw_resource) do
    # This works because shopify uses the convention of {"resource_name": resource}
    # for their JSON REST-API, if they ever decide to put a second value in the top level
    # it will get a lot harder to know what the resource name is.
    resource = raw_resource |> Map.values() |> List.first()
    key = raw_resource |> Map.keys |> List.first
    put_id(key, resource)
  end

  defp put_id(key, resource) when is_map(resource) do
    %{key => Map.put_new(resource, "id", 1)}
  end

  # For all I know, only engagements need this special treatment...
  defp put_id(key, resources) when is_list(resources) do
    resources = Enum.map(resources, &Map.put_new(&1, "id", 1))
    %{key => resources}
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

  def oauth_auth(_) do
  end
end
