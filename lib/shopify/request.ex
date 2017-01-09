defmodule Shopify.Request do
  defstruct [
    :session,
    :url,
    :params,
    :resource,
    :body
  ]

  @doc """
  Creates a new %Shopify.Request{} from provided values.

  Returns %Shopify.Request{}

  ## Parameters
    - session: A %Shopify.Session{} struct.
    - path: The path of the resource we are requesting.
    - params: Any additional query params.
    - body: The body of our request.
  """
  def new(session, path, params \\ %{}, resource, body \\ nil) do
    %Shopify.Request{
      session: session,
      url: session.base_url <> path,
      params: params,
      resource: resource,
      body: body
    }
  end

  @doc """
  Performs an HTTP GET request.

  Returns {:ok, resource} or {:error, %Shopify.Error{}}

  ## Parameters
    - request: A %Shopify.Request{} struct.
  """
  def get(request) do
    HTTPoison.get(request.url, request.session.headers, params: request.params)
      |> parse_json(request.resource)
      |> handle_response
  end

  @doc """
  Performs an HTTP POST request.

  Returns {:ok, resource} or {:error, %Shopify.Error{}}

  ## Parameters
    - request: A %Shopify.Request{} struct.
  """
  def post(request) do
    HTTPoison.post(request.url, request.body, request.session.headers)
      |> parse_json(request.resource)
      |> handle_response
  end

  @doc """
  Performs an HTTP PUT request.

  Returns {:ok, resource} or {:error, %Shopify.Error{}}

  ## Parameters
    - request: A %Shopify.Request{} struct.
  """
  def put(request) do
    HTTPoison.put(request.url, request.body, request.session.headers)
      |> parse_json(request.resource)
      |> handle_response
  end

  @doc """
  Performs an HTTP DELETE request.

  Returns {:ok, resource} or {:error, %Shopify.Error{}}

  ## Parameters
    - request: A %Shopify.Request{} struct.
  """
  def delete(request) do
    HTTPoison.delete(request.url, request.session.headers)
      |> parse_json(request.resource)
      |> handle_response
  end

  @doc false
  defp parse_json({:ok, %HTTPoison.Response{status_code: 200, body: body}}, resource) do
    Poison.decode(body, as: resource)
  end
  defp parse_json({:ok, %HTTPoison.Response{status_code: 201, body: body}}, resource) do
    Poison.decode(body, as: resource)
  end
  defp parse_json({:ok, response}, _) do
    {:error, response}
  end

  @doc false
  defp handle_response({:ok, response}) do
    {:ok, response |> Map.values |> List.first}
  end
  defp handle_response({:error, response}) do 
    response |> Shopify.Error.from_response
  end
end