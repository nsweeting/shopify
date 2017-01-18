defmodule Shopify.NestedResource do
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
          - top_id: The id of the top-level resource.
          - nest_id: The id of the nest-level resource.
          - params: Any additional query params.
          
        ## Examples
            iex> Shopify.session |> Shopify.Transaction.find(order_id, transaction_id)
            {:ok, %Shopify.Response{}}
        """
        def find(%Session{} = session, top_id, nest_id, params \\ %{}) do
          session
            |> Request.new(find_url(top_id, nest_id), params, singular_resource())
            |> Client.get
        end
      end

      if :all in import_functions do
        @doc """
        Requests all resources.

        Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - top_id: The id of the top-level resource.
          - params: Any additional query params.
          
        ## Examples
            iex> Shopify.session |> Shopify.Transaction.all(order_id)
            {:ok, %Shopify.Response{}}
        """
        def all(%Session{} = session, top_id, params \\ %{}) do
          session
            |> Request.new(all_url(top_id), params, plural_resource())
            |> Client.get
        end
      end

      if :count in import_functions do
        @doc """
        Requests the resource count.

        Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - top_id: The id of the top-level resource.
          - params: Any additional query params.
          
        ## Examples
            iex> Shopify.session |> Shopify.Transaction.count(order_id)
            {:ok, %Shopify.Response{}}
        """
        def count(%Session{} = session, top_id, params \\ %{}) do
          session
            |> Request.new(count_url(top_id), params, nil)
            |> Client.get
        end
      end

      if :create in import_functions do
        @doc """
        Requests to create a new resource.

        Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - top_id: The id of the top-level resource.
          - new_resource: A struct of the resource being created.
          
        ## Examples
            iex> Shopify.session |> Shopify.Transaction.create(order_id)
            {:ok, %Shopify.Response{}}
        """
        def create(%Session{} = session, top_id, new_resource) do
          body = new_resource |> to_json
          session
            |> Request.new(all_url(top_id), %{}, singular_resource(), body)
            |> Client.post
        end
      end

      if :update in import_functions do
        @doc """
        Requests to update a resource by id.

        Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Error{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - top_id: The id of the top-level resource.
          - nest_id: The id of the nested-level resource.
          - updated_resource: A struct of the resource being updated.
          
        ## Examples
            iex> Shopify.session |> Shopify.CustomerAddress.update(customer_id, address_id)
            {:ok, %Shopify.Response{}}
        """
        def update(%Session{} = session, top_id, nest_id, updated_resource) do
          body = updated_resource |> to_json
          session
            |> Request.new(find_url(top_id, nest_id), %{}, singular_resource(), body)
            |> Client.put
        end
      end

      if :delete in import_functions do
        @doc """
        Requests to delete a resource by id.

        Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

        ## Parameters
          - session: A `%Shopify.Session{}` struct.
          - top_id: The id of the top-level resource.
          - nest_id: The id of the nested resource.
          
        ## Examples
            iex> Shopify.session |> Shopify.CustomerAddress.delete(customer_id, address_id)
            {:ok, %Shopify.Response{}}
        """
        def delete(%Session{} = session, top_id, nest_id) do
          session
            |> Request.new(find_url(top_id, nest_id), %{}, nil)
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