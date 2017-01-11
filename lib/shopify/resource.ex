defmodule Shopify.Resource do
  defmacro __using__(options) do
    import_functions = options[:import] || []
    
    quote bind_quoted: [import_functions: import_functions] do
      alias Shopify.{Request, API}

      if :find in import_functions do
        @doc """
        Requests a resource by id.

        Returns `{:ok, resource}` or `{:error, %Shopify.Error{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - id: The id of the resource.
          - params: Any additional query params.
          
        ## Examples
            iex> Shopify.session |> Shopify.Product.find(id)
            {:ok, %Shopify.Product{}}
        """
        def find(session, id, params \\ %{}) do
          session
            |> Request.new(find_url(id), params, singular_resource())
            |> Request.get
            |> handle_response
        end
      end

      if :all in import_functions do
        @doc """
        Requests all resources.

        Returns `{:ok, [resources]}` or `{:error, %Shopify.Error{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - params: Any additional query params.
          
        ## Examples
            iex> Shopify.session |> Shopify.Product.all
            {:ok, [%Shopify.Product{}]}
        """
        def all(session, params \\ %{}) do
          session
            |> Request.new(all_url(), params, plural_resource())
            |> Request.get
            |> handle_response
        end
      end

      if :count in import_functions do
        @doc """
        Requests the resource count.

        Returns `{:ok, integer}` or `{:error, %Shopify.Error{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - params: Any additional query params.
          
        ## Examples
            iex> Shopify.session |> Shopify.Product.count
            {:ok, 1}
        """
        def count(session, params \\ %{}) do
          session
            |> Request.new(count_url(), params, nil)
            |> Request.get
            |> handle_response
        end
      end

      if :search in import_functions do
        @doc """
        Requests all resources based of search params.

        Returns `{:ok, [resources]}` or `{:error, %Shopify.Error{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - params: Any additional query params.
          
        ## Examples
            iex> Shopify.session |> Shopify.Product.search
            {:ok, [%Shopify.Product{}]}
        """
        def search(session, params \\ %{}) do
          session
            |> Request.new(search_url(), params, plural_resource())
            |> Request.get
            |> handle_response
        end
      end

      if :create in import_functions do
        @doc """
        Requests to create a new resource.

        Returns `{:ok, resource}` or `{:error, %Shopify.Error{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - new_resource: A struct of the resource being created.
          
        ## Examples
            iex> Shopify.session |> Shopify.Product.create(%Shopify.Product{})
            {:ok, %Shopify.Product{}}
        """
        def create(session, new_resource) do
          body = new_resource |> to_json
          session
            |> Request.new(all_url(), %{}, singular_resource(), body)
            |> Request.post
            |> handle_response
        end
      end

      if :update in import_functions do
        @doc """
        Requests to update a resource by id.

        Returns `{:ok, resource}` or `{:error, %Shopify.Error{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - id: The id of the resource.
          - updated_resource: A struct of the resource being updated.
          
        ## Examples
            iex> Shopify.session |> Shopify.Product.update(id, %Shopify.Product{})
            {:ok, %Shopify.Product{}}
        """
        def update(session, id, updated_resource) do
          body = updated_resource |> to_json
          session
            |> Request.new(find_url(id), %{}, singular_resource(), body)
            |> Request.put
            |> handle_response
        end
      end

      if :delete in import_functions do
        @doc """
        Requests to delete a resource by id.

        Returns `{:ok, resource}` or `{:error, %Shopify.Error{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - id: The id of the resource.
          
        ## Examples
            iex> Shopify.session |> Shopify.Product.delete(id)
            {:ok, nil}
        """
        def delete(session, id) do
          session
            |> Request.new(find_url(id), %{}, nil)
            |> Request.delete
            |> handle_response
        end
      end

      @doc false
      def singular_resource, do:  %{@singular => empty_resource()}
      def singular_resource(new_resource) do
        %{@singular => new_resource}
      end
      @doc false
      def plural_resource, do: %{@plural => [empty_resource()]}

      @doc false
      def to_json(resource) do
        resource
          |> Map.from_struct
          |> Enum.filter(fn {_, v} -> v != nil end)
          |> Enum.into(%{})
          |> singular_resource
          |> Poison.encode!
      end

      @doc false
      defp handle_response({:ok, response}) do
        {:ok, response |> Map.values |> List.first}
      end
      defp handle_response({:error, response}) do 
        response |> Shopify.Error.from_response
      end
    end
  end
end