defmodule Shopify.Base do
  defmacro __using__(_) do
    quote do
      def find(session, scope \\ %{}) do
        Shopify.Worker.perform([__MODULE__, {session, :find, scope}])
      end

      def request({session, :find, id}) when is_integer(id) do
        session
          |> full_url(id)
          |> get_request
          |> parse_json(resource_base)
          |> handle_response
      end

      def request({session, :find, options}) when is_map(options) do
        session
          |> full_url
          |> get_request(options)
          |> parse_json(resources_base)
          |> handle_response
      end

      defp full_url(session, id) when is_integer(id) do
        {session, session.base_url <> resource_url(id)}
      end

      defp full_url(session) do
        {session, session.base_url <> resource_url}
      end

      defp get_request({session, full_url}, options \\ %{}) do
        full_url |> HTTPoison.get(session.headers, params: options)
      end

      defp parse_json({:ok, %HTTPoison.Response{status_code: 200, body: body}}, resource) do
        Poison.decode(body, as: resource)
      end
      defp parse_json({:ok, response}, _) do
        response |> Shopify.Error.from_response
      end

      defp resource_url, do: @resources <> ".json"
      defp resource_url(id), do: @resources <> "/#{id}.json"

      defp resource_base, do:  %{@resource => new()}
      defp resources_base, do: %{@resources => [new()]}

      defp handle_response({:ok, response}) do
        {:ok, response |> Map.values |> List.first}
      end
      defp handle_response({:error, error}), do: {:error, error}
    end
  end
end