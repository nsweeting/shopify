defmodule Shopify.OAuth do
  defstruct [
    :access_token,
    :scope,
    :expires_in,
    :associated_user_scope,
    :associated_user
  ]

  alias Shopify.Request

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
    params = params
      |> Map.merge(%{client_id: session.client_id})
      |> URI.encode_query
    session.base_url <> "oauth/authorize?" <> params
  end

  @doc """
  Requests a new access token for a shop.

  Returns `{:ok, %Shopify.Oauth{}}` or `{:error, %Shopify.Error{}}`

  ## Parameters
    - session: A %Shopify.Session{} struct.
    - code: The code returned to your redirect_uri after permission has been granted.
    
  ## Examples
      iex> Shopify.session("shop-name") |> Shopify.OAuth.request_token("code")
      %Shopify.OAuth{access_token: "access-token", associated_user: nil, associated_user_scope: nil, expires_in: nil, scope: "read_orders"}}
  """
  def request_token(session, code) do
    body = %{
      code: code,
      client_id: session.client_id,
      client_secret: session.client_secret
    } |> Poison.encode!

    session
      |> Request.new("oauth/access_token", %{}, %Shopify.OAuth{}, body)
      |> Request.post
      |> handle_response
  end

  @doc false
  defp handle_response({:ok, response}) do
    {:ok, response}
  end
  defp handle_response({:error, response}) do 
    response |> Shopify.Error.from_response
  end
end