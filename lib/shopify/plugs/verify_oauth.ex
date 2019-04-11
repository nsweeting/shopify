defmodule Shopify.Plugs.VerifyOAuth do
  @moduledoc """
  Validates the request originated from Shopify.
  If one exists, it let's the request continue, otherwise it haults the request and calls the handler function from the handler module.

  Note that this *does not* authenticate a shop, it only verifies that the request came from Shopify.

  # Usage

  Add this to your `router.ex`, possibly inside a pipeline:

      plug Shopify.Plugs.VerifyOAuth,
        handler: MyApp.PageController  # (required) The handler module
        handler_fn: :handle_error      # (optional) Customize the handler function, defaults to :unauthenticated
  """

  import Plug.Conn

  @doc false
  def init(opts), do: opts

  @doc false
  def call(conn, opts) do
    handler    = Keyword.get(opts, :handler)
    handler_fn = Keyword.get(opts, :handler_fn, :unauthenticated)
    case verify_hmac(conn.params) do
      nil ->
        conn = conn |> halt
        apply(handler, handler_fn, [conn, conn.params])
      _ ->
        conn
        |> assign(:shop, conn.params["shop"])
    end
  end

  defp verify_hmac(params) do
    params["shop"]
    |> Shopify.session()
    |> Shopify.OAuth.authenticate(params)
  end

end
