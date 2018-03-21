defmodule Shopify.Request do
  @moduledoc false

  @headers [
    "Content-Type": "application/json",
    "Keep-Alive": "timeout=15, max=100",
    "user-agent": "ShopifyElixir/#{Shopify.Config.version()}"
  ]

  defstruct [
    :type,
    :full_url,
    :path,
    :resource,
    :body,
    :headers
  ]

  def new(session, path, params \\ %{}, resource, body \\ nil) do
    %Shopify.Request{
      full_url: session |> build_full_url(path) |> add_query(params),
      path: path,
      resource: resource,
      body: body,
      headers: session |> build_headers
    }
  end

  defp build_headers(session) do
    case session.type do
      :basic -> @headers
      :oauth -> @headers ++ ["X-Shopify-Access-Token": session.access_token]
    end
  end

  defp build_full_url(session, path) do
    shop_path =
      case session.type do
        :basic -> "#{session.api_key}:#{session.password}@#{session.shop_name}"
        :oauth -> session.shop_name
      end

    "https://#{shop_path}.myshopify.com/admin/" <> path
  end

  defp add_query(full_url, params) do
    query = URI.encode_query(params)

    if String.contains?(full_url, "?") do
      full_url <> "&" <> query
    else
      full_url <> "?" <> query
    end
  end
end
