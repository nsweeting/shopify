defmodule Shopify.Request do
  @moduledoc false
  
  defstruct [
    :session,
    :url,
    :params,
    :resource,
    :body
  ]

  def new(session, path, params \\ %{}, resource, body \\ nil) do
    %Shopify.Request{
      session: session,
      url: session.base_url <> path,
      params: params,
      resource: resource,
      body: body
    }
  end

  def get(request) do
    HTTPoison.get(request.url, request.session.headers, params: request.params)
      |> parse_json(request.resource)
  end

  def post(request) do
    HTTPoison.post(request.url, request.body, request.session.headers)
      |> parse_json(request.resource)
  end

  def put(request) do
    HTTPoison.put(request.url, request.body, request.session.headers)
      |> parse_json(request.resource)
  end

  def delete(request) do
    HTTPoison.delete(request.url, request.session.headers)
      |> parse_json(request.resource)
  end

  defp parse_json({:ok, %HTTPoison.Response{status_code: 200, body: body}}, resource) do
    Poison.decode(body, as: resource)
  end
  defp parse_json({:ok, %HTTPoison.Response{status_code: 201, body: body}}, resource) do
    Poison.decode(body, as: resource)
  end
  defp parse_json({:ok, response}, _) do
    {:error, response}
  end
end