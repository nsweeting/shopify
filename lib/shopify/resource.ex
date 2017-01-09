defmodule Shopify.Resource do
  defmacro __using__(options) do
    import_functions = options[:import] || []
    
    quote bind_quoted: [import_functions: import_functions] do
      alias Shopify.{Request, API}

      if :find in import_functions do
        def find(session, id, params \\ %{}) do
          session
            |> Request.new(find_url(id), params, singular_resource())
            |> Request.get
        end
      end

      if :all in import_functions do
        def all(session, params \\ %{}) do
          session
            |> Request.new(all_url(), params, plural_resource())
            |> Request.get
        end
      end

      if :count in import_functions do
        def count(session, params \\ %{}) do
          session
            |> Request.new(count_url(), params, nil)
            |> Request.get
        end
      end

      if :search in import_functions do
        def search(session, params \\ %{}) do
          session
            |> Request.new(search_url(), params, nil)
            |> Request.get
        end
      end

      if :create in import_functions do
        def create(session, new_resource) do
          body = new_resource |> to_json
          session
            |> Request.new(all_url(), %{}, singular_resource(), body)
            |> Request.post
        end
      end

      if :update in import_functions do
        def update(session, id, updated_resource) do
          body = updated_resource |> to_json
          session
            |> Request.new(find_url(id), %{}, singular_resource(), body)
            |> Request.put
        end
      end

      if :delete in import_functions do
        def delete(session, id) do
          session
            |> Request.new(find_url(id), %{}, nil)
            |> Request.delete
        end
      end

      def singular_resource, do:  %{@singular => empty_resource()}
      def singular_resource(new_resource) do
        %{@singular => new_resource}
      end
      def plural_resource, do: %{@plural => [empty_resource()]}

      def to_json(resource) do
        {:ok, json} = resource
          |> Map.from_struct
          |> Enum.filter(fn {_, v} -> v != nil end)
          |> Enum.into(%{})
          |> singular_resource
          |> Poison.encode
        json
      end
    end
  end
end