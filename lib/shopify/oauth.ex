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
end
