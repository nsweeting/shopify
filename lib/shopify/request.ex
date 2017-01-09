defmodule Shopify.Request do
  defstruct [
    :session,
    :url,
    :params,
    :resource,
    :body
  ]

  def new(session, url, params \\ %{}, resource, body \\ nil) do
    %Shopify.Request{
      session: session,
      url: session.base_url <> url,
      params: params,
      resource: resource,
      body: body
    }
  end

  def get(request) do
    HTTPoison.get(request.url, request.session.headers, params: request.params)
      |> parse_json(request.resource)
      |> handle_response
  end

  def post(request) do
    HTTPoison.post(request.url, request.body, request.session.headers)
      |> parse_json(request.resource)
      |> handle_response
  end

  def put(request) do
    HTTPoison.put(request.url, request.body, request.session.headers)
      |> parse_json(request.resource)
      |> handle_response
  end

  def delete(request) do
    HTTPoison.delete(request.url, request.session.headers)
      |> parse_json(request.resource)
      |> handle_response
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

  defp handle_response({:ok, response}) do
    {:ok, response |> Map.values |> List.first}
  end
  defp handle_response({:error, response}) do 
    response |> Shopify.Error.from_response
  end
end