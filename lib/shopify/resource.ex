defmodule Shopify.Resource do
  defmacro __using__(options) do
    import_functions = options[:import] || []
    
    quote bind_quoted: [import_functions: import_functions] do
      alias Shopify.{Client, Request, Session}

      if :find in import_functions do
        @doc """
        Requests a resource by id.

        Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - id: The id of the resource.
          - params: Any additional query params.
          
        ## Examples
            iex> Shopify.session |> Shopify.Product.find(id)
            {:ok, %Shopify.Response{}}
        """
        def find(session, id, params \\ %{}) do
          session
            |> Request.new(find_url(id), params, singular_resource())
            |> Client.get
        end
      end

      if :all in import_functions do
        @doc """
        Requests all resources.

        Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - params: Any additional query params.
          
        ## Examples
            iex> Shopify.session |> Shopify.Product.all
            {:ok, %Shopify.Response{}}
        """
        def all(session, params \\ %{}) do
          session
            |> Request.new(all_url(), params, plural_resource())
            |> Client.get
        end
      end

      if :count in import_functions do
        @doc """
        Requests the resource count.

        Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - params: Any additional query params.
          
        ## Examples
            iex> Shopify.session |> Shopify.Product.count
            {:ok, %Shopify.Response{}}
        """
        def count(session, params \\ %{}) do
          session
            |> Request.new(count_url(), params, nil)
            |> Client.get
        end
      end

      if :search in import_functions do
        @doc """
        Requests all resources based of search params.

        Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - params: Any additional query params.
          
        ## Examples
            iex> Shopify.session |> Shopify.Product.search
            {:ok, %Shopify.Response{}}
        """
        @spec search(%Shopify.Session{}, map) :: {:ok, list} | {:error, map}
        def search(session, params \\ %{}) do
          session
            |> Request.new(search_url(), params, plural_resource())
            |> Client.get
        end
      end

      if :create in import_functions do
        @doc """
        Requests to create a new resource.

        Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - new_resource: A struct of the resource being created.
          
        ## Examples
            iex> Shopify.session |> Shopify.Product.create(%Shopify.Product{})
            {:ok, %Shopify.Response{}}
        """
        @spec create(%Shopify.Session{}, map) :: {:ok, list} | {:error, map}
        def create(session, new_resource) do
          body = new_resource |> to_json
          session
            |> Request.new(all_url(), %{}, singular_resource(), body)
            |> Client.post
        end
      end

      if :update in import_functions do
        @doc """
        Requests to update a resource by id.

        Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - id: The id of the resource.
          - updated_resource: A struct of the resource being updated.
          
        ## Examples
            iex> Shopify.session |> Shopify.Product.update(id, %Shopify.Product{})
            {:ok, %Shopify.Response{}}
        """
        def update(session, id, updated_resource) do
          body = updated_resource |> to_json
          session
            |> Request.new(find_url(id), %{}, singular_resource(), body)
            |> Client.put
        end
      end

      if :delete in import_functions do
        @doc """
        Requests to delete a resource by id.

        Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - id: The id of the resource.
          
        ## Examples
            iex> Shopify.session |> Shopify.Product.delete(id)
            {:ok, %Shopify.Response{}}
        """
        def delete(session, id) do
          session
            |> Request.new(find_url(id), %{}, nil)
            |> Client.delete
        end
      end

      @doc false
      def singular_resource do
        %{@singular => empty_resource()}
      end
      @doc false
      def singular_resource(new_resource) do
        %{@singular => new_resource}
      end

      @doc false
      def plural_resource do
        %{@plural => [empty_resource()]}
      end

      @doc false
      def to_json(resource) do
        resource
          |> Map.from_struct
          |> Enum.filter(fn {_, v} -> v != nil end)
          |> Enum.into(%{})
          |> singular_resource
          |> Poison.encode!
      end
    end
  end
end