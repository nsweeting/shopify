defmodule Shopify.Adapters.HTTP do
  @moduledoc false

  @behaviour Shopify.Adapters.Base
  @options [hackney: [pool: :shopify], ssl: [{:versions, [:"tlsv1.2"]}]]

  def get(request) do
    request.full_url
    |> HTTPoison.get(request.headers, merge_options(request.opts))
    |> handle_response(request.resource)
  end

  def post(request) do
    request.full_url
    |> HTTPoison.post(request.body || "", request.headers, merge_options(request.opts))
    |> handle_response(request.resource)
  end

  def put(request) do
    request.full_url
    |> HTTPoison.put(request.body || "", request.headers, merge_options(request.opts))
    |> handle_response(request.resource)
  end

  def delete(request) do
    request.full_url
    |> HTTPoison.delete(request.headers, merge_options(request))
    |> handle_response(request.resource)
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: code, body: body}}, resource) do
    Shopify.Response.new(code, body, resource)
  end

  def handle_response({:error, %HTTPoison.Error{reason: reason}}, _resource) do
    {:error, %Shopify.Error{reason: reason, source: :httpoison}}
  end

  defp merge_options(opts) when is_list(opts) do
    Keyword.merge(@options, opts)
  end

  defp merge_options(_) do
    @options
  end
end
