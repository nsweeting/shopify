defmodule Shopify.Adapters.MockUtils do
  @moduledoc """
  Some useful functions to help implementing a mock adapter.
  """

  @doc """
  Puts an id into resources, usefull for create options that would otherwise return
  the resource built from the body without an id.
  """
  @spec put_id(map | list(map), integer) :: map
  def put_id(raw_resource, id \\ 1) do
    # This works because shopify uses the convention of {"resource_name": resource}
    # for their JSON REST-API, if they ever decide to put a second value in the top level
    # it will get a lot harder to know what the resource name is.
    resource = raw_resource |> Map.values() |> List.first()
    key = raw_resource |> Map.keys() |> List.first()
    do_put_id(key, resource, id)
  end

  defp do_put_id(key, resource, id) when is_map(resource) do
    %{key => Map.put_new(resource, "id", id)}
  end

  defp do_put_id(key, resources, id) when is_list(resources) do
    # For all I know, only engagements need this special treatment...
    resources = Enum.map(resources, &Map.put_new(&1, "id", id))
    %{key => resources}
  end

  @doc """
  Filter resources if query params given and the resource is a list.

  This is a naive implementation that will fail whenever the query parameter keys do
  not correspond to the resource keys.

  ## Examples
      iex> Shopify.Adapters.MockUtils.filter_resources({:ok, %Shopify.Response{data: [%{a: "a"}, %{a: "b"}]}}, %Shopify.Request{query_params: %{a: "a"}})
      {:ok, %Shopify.Response{code: nil, data: [%{a: "a"}]}}

      iex> Shopify.Adapters.MockUtils.filter_resources({:ok, %Shopify.Response{data: [%{a: "a"}, %{a: "b"}, %{a: "c"}]}}, %Shopify.Request{query_params: %{a: ["a", "b"]}})
      {:ok, %Shopify.Response{code: nil, data: [%{a: "a"}, %{a: "b"}]}}
  """
  @spec filter_resources(
          Shopify.Adapters.Base.success() | Shopify.Adapters.Base.error(),
          Shopify.Request.t()
        ) :: Shopify.Adapters.Base.success() | Shopify.Adapters.Base.error()
  def filter_resources({:ok, %{data: resources} = resp}, %{query_params: params})
      when is_list(resources),
      do: {:ok, %{resp | data: do_filter_resources(resources, params, [])}}

  def filter_resources(resp, _), do: resp

  defp do_filter_resources([], _, filtered), do: filtered

  defp do_filter_resources([resource | rest], params, filtered) do
    is_in_query =
      params
      |> Map.keys()
      |> Enum.reduce(true, fn key, acc ->
        acc && resource_in_query(Map.fetch(resource, key), Map.fetch(params, key))
      end)

    if is_in_query do
      do_filter_resources(rest, params, filtered ++ [resource])
    else
      do_filter_resources(rest, params, filtered)
    end
  end

  defp resource_in_query({:ok, resource_val}, {:ok, query_val}) when is_list(query_val),
    do: resource_val in query_val

  defp resource_in_query({:ok, resource_val}, {:ok, query_val}), do: resource_val == query_val

  # This is the case where the resource does not have that key. Lets just ignore it.
  defp resource_in_query(:error, _), do: true
end
