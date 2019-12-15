defmodule Shopify.OAuth do
  defstruct [
    :access_token,
    :scope,
    :expires_in,
    :associated_user_scope,
    :associated_user
  ]

  alias Shopify.{Client, Request}

  @doc """
  Builds a new permission url for a shop.

  Returns "https://shop-name.myshopify.com/admin/oauth/authorize?"

  ## Parameters
    - session: A %Shopify.Session{} struct.
    - params: A map of additional query params.
    
  ## Examples
      iex> Shopify.session("shop-name") |> Shopify.OAuth.permission_url(%{scope: "read_orders", redirect_uri: "http://my-url.com/"})
      "https://shop-name.myshopify.com/admin/oauth/authorize?client_id=CLIENTID&redirect_uri=http%3A%2F%2Fmy-url.com%2F&scope=read_orders"
  """
  def permission_url(session, params \\ %{}) do
    params = Map.merge(params, %{client_id: session.client_id})
    request = session |> Request.new("oauth/authorize", params, nil)
    request.full_url
  end

  @doc """
  Requests a new access token for a shop.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A %Shopify.Session{} struct.
    - code: The code returned to your redirect_uri after permission has been granted.
    
  ## Examples
      iex> Shopify.session("shop-name") |> Shopify.OAuth.request_token("code")
      %Shopify.Response{code: 200, data: %Shopify.OAuth{access_token: "access-token", associated_user: nil, associated_user_scope: nil, expires_in: nil, scope: "read_orders"}}
      
  """
  def request_token(session, code) do
    body =
      %{
        code: code,
        client_id: session.client_id,
        client_secret: session.client_secret
      }
      |> Poison.encode!()

    session
    |> Request.new("oauth/access_token", %{}, %Shopify.OAuth{}, body)
    |> Client.post()
  end

  @doc """
  Validates the hmac signature of a Shopify request using the Session's secret

  Returns `Shopify.Session` or `nil`

  ## Parameters
    - session: A %Shopify.Session{} struct.
    - params: A map of additional query params.
    
  ## Examples
      iex> Shopify.session("shop-name") |> Shopify.OAuth.authenticate(params)
      %Shopify.Session{}
      
  """
  def authenticate(session, params) do
    case valid_hmac?(session.client_secret, params) do
      true -> session
      _    -> nil
    end
  end

  defp valid_hmac?(secret, params) do
    hmac  = params["hmac"]

    :crypto.hmac(:sha256, secret, query_string(params))
    |> Base.encode16(case: :lower)
    |> String.equivalent?(hmac)
  end

  defp query_string(query, nil) do
    query
  end

  defp query_string(query, ids) do
    # Convert the ids to a string representing and array of numeric strings:
    # ["1", "2", "3"]
    ids = ids
    |> Enum.map(fn x -> "\"#{x}\"" end)
    |> Enum.join(", ")

    # Concatenate the ids back to the query - they must not be URI encoded!
    # https://community.shopify.com/c/Shopify-APIs-SDKs/HMAC-calculation-vs-ids-arrays/m-p/261154
    "ids=[#{ids}]&#{query}"
  end

  defp query_string(params) when is_map(params) do
    # Extract the ids
    ids = params["ids"]

    # Remove the ids & hmac parameters and make a query string
    query = params
    |> Map.delete("ids")
    |> Map.delete("hmac")
    |> URI.encode_query

    query_string(query, ids)
  end
end
