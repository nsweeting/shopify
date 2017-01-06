defmodule Shopify.Count do
  defmacro __using__(_) do
    quote do
      def count(session) do
        Shopify.Worker.perform([__MODULE__, {session, :count, nil}])
      end

      def request({session, :count, _}) do
        session
          |> full_url(:count)
          |> get_request
          |> parse_json(nil)
          |> handle_response
      end

      defp full_url(session, :count) do
        {session, session.base_url <> resource_count_url}
      end

      defp resource_count_url, do: @resources <> "/count.json"
    end
  end
end