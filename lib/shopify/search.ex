defmodule Shopify.Search do
  defmacro __using__(_) do
    quote do
      def search(session, scope) do
        Shopify.Worker.perform([__MODULE__, {session, :search, scope}])
      end

      def request({session, :search, options}) do
        session
          |> full_url(:search)
          |> get_request(options)
          |> parse_json(resources_base)
          |> handle_response
      end

      defp full_url(session, :search) do
        {session, session.base_url <> resource_search_url()}
      end

      defp resource_search_url, do: @resources <> "/search.json"
    end
  end
end