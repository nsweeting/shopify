defmodule Shopify.Pagination do
  @moduledoc """
  Functions for performing cursor-based pagination. API versions prior to `"2019-10"` do not
  support cursor-based pagination on all endpoints. See [Shopify's
  documentation](https://help.shopify.com/en/api/guides/paginated-rest-results) for details.
  """

  alias Shopify.Response

  @doc """
  Returns an enumerable for iterating over Shopify items. In particular, this enumerable can be
  used with any of the functions in the `Enum` or `Stream` modules. The enumerable is lazy; no
  requests are made until iteration begins. It will automatically load additional pages of data as
  needed.

  If an error occurs while fetching a page of data then `Shopify.Error` will be raised.

  ## Arguments

    * `session` - A `Shopify.Session` struct. See `Shopify.session/0`.
    * `func` - Function with an arity of 2 that accepts a `Shopify.Session` record and a map of
      query params. For example, this value could be `&Shopify.Product.all/2` to iterate over
      products or `&Shopify.Order.all/2` to iterate over orders.
    * `params` - Map of query params to be passed to `func` when fetching the first page. By
      default, most Shopify endpoints for listing items will return 50 items per page. If you plan
      on iterating over a large number of items then it will be more efficient to request the
      maximum number of items per page by specifying `%{limit: 250}`.

  ## Options

    * `:middleware` - An optional middleware function whose primary purpose is to allow an
      application to throttle requests to avoid going over Shopify's rate limit. Must be a
      function with an arity of 1 that will be passed another function. The middleware must call
      that function and return the value returned by that function, which will be `{:ok,
      %Shopify.Response{}}` or `{:error, %Shopify.Error{}}`. Defaults to `& &1.()`.

  ## Example

      Shopify.session() |> Shopify.Pagination.enumerable(&Shopify.Product.all/2)
      |> Stream.each(fn product -> IO.puts(product.id) end)
      |> Stream.run()

  """
  def enumerable(session, func, params \\ %{}, opts \\ [])

  def enumerable(session, func, params, opts) when is_list(params) do
    enumerable(session, func, Enum.into(params, %{}), opts)
  end

  def enumerable(%Shopify.Session{} = session, func, %{} = params, opts)
      when is_function(func) and is_list(opts) do
    %Shopify.Enumerable{
      data: [],
      func: func,
      middleware: Keyword.get(opts, :middleware, & &1.()),
      params: params,
      session: session
    }
  end

  @doc """
  Returns a map containing the query params needed to fetch the next page of results when passed a
  `Shopify.Response` struct. It will return `nil` if there are no additional pages. This map will
  contain `"limit"` and `"page_info"` keys as [documented by
  Shopify](https://help.shopify.com/en/api/guides/paginated-rest-results).

  If any sorting or filtering params were passed with the API call for the first page then these
  params do not need to be passed when fetching subsequent pages. This information is encoded into
  the `page_info` value.

  ## Example

      {:ok, resp} = Shopify.session() |> Shopify.Product.all()
      case Shopify.Pagination.next_page_params(resp) do
         nil ->
           # no additional pages
           nil
         page_params ->
           # fetch the next page
           {:ok, resp} = Shopify.session() |> Shopify.Product.all(page_params)
           # and so on...
       end
  """
  def next_page_params(resp), do: page_params(resp, "next")

  defp page_params(%Response{headers: headers}, rel) do
    Enum.find_value(headers, fn {k, v} ->
      with "link" <- String.downcase(k),
           url when is_binary(url) <- parse_link_header(v)[rel],
           %URI{query: query} = URI.parse(url) do
        URI.decode_query(query)
      else
        _ -> nil
      end
    end)
  end

  # Returns map like %{"next" => <url>, "previous" => <url>}. Logic inspired by
  # https://github.com/Shopify/shopify_api/blob/master/lib/shopify_api/pagination_link_headers.rb
  defp parse_link_header(header) do
    header
    |> String.split(",")
    |> Enum.map(fn link ->
      [url_part, rel_part] = String.split(link, "; ")
      [rel] = Regex.run(~R{rel="(.*)"}, rel_part, capture: :all_but_first)
      [url] = Regex.run(~R{<(.*)>}, url_part, capture: :all_but_first)

      {rel, url}
    end)
    |> Enum.into(%{})
  end
end
