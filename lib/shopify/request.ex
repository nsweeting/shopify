defmodule Shopify.Request do
  @moduledoc false

  @type t :: %__MODULE__{
          full_url: String.t(),
          path: String.t(),
          resource: map,
          body: String.t(),
          headers: list,
          query_params: map,
          opts: Keyword.t()
        }

  @headers [
    "Content-Type": "application/json",
    "Keep-Alive": "timeout=#{Shopify.Config.request_timeout()}, max=100",
    "user-agent": "ShopifyElixir/#{Shopify.Config.version()}"
  ]

  defstruct [
    :full_url,
    :path,
    :resource,
    :body,
    :headers,
    :query_params,
    :opts
  ]

  def new(session, path, params \\ %{}, resource, body \\ nil) do
    %Shopify.Request{
      full_url: session |> build_full_url(path) |> add_query(params),
      path: path,
      resource: resource,
      body: body,
      headers: build_headers(session),
      query_params: params,
      opts: session.req_opts
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

    api_version =
      case session.api_version do
        api_version when is_binary(api_version) -> "api/#{api_version}/"
        _ -> nil
      end

    "https://#{shop_path}.myshopify.com/admin/#{api_version}#{path}"
  end

  defp add_query(full_url, params)
  defp add_query(full_url, params) when map_size(params) == 0, do: full_url

  defp add_query(full_url, params) do
    query =
      params
      |> scrub_params()
      |> URI.encode_query()

    if String.contains?(full_url, "?") do
      full_url <> "&" <> query
    else
      full_url <> "?" <> query
    end
  end

  defp scrub_params(params) do
    do_scrub_params(%{}, Map.keys(params), params)
  end

  defp do_scrub_params(scrubbed, [], _), do: scrubbed

  defp do_scrub_params(scrubbed, [key | rest], params) do
    scrubbed
    |> Enum.into(%{key => scrub_value(params[key])})
    |> do_scrub_params(rest, params)
  end

  defp scrub_value(val) when is_list(val), do: Enum.join(val, ",")
  defp scrub_value(val), do: val
end
