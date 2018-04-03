defmodule Shopify.Adapters.HTTP do
  @moduledoc false

  @behaviour Shopify.Adapters.Base
  @options [hackney: [pool: :shopify], ssl: [{:versions, [:"tlsv1.2"]}]]

  def get(request) do
    HTTPoison.get(request.full_url, request.headers, @options)
    |> handle_response(request.resource)
  end

  def post(request) do
    HTTPoison.post(request.full_url, request.body || "", request.headers, @options)
    |> handle_response(request.resource)
  end

  def put(request) do
    HTTPoison.put(request.full_url, request.body || "", request.headers, @options)
    |> handle_response(request.resource)
  end

  def delete(request) do
    HTTPoison.delete(request.full_url, request.headers, @options)
    |> handle_response(request.resource)
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: code, body: body}}, resource) do
    Shopify.Response.new(code, body, resource)
  end
end
