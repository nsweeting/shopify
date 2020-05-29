defmodule Shopify.Enumerable do
  @moduledoc false

  alias Shopify.{Error, Pagination, Response}

  @enforce_keys [:data, :func, :middleware, :params, :session]
  defstruct @enforce_keys

  defimpl Enumerable do
    # See https://hexdocs.pm/elixir/Enumerable.html

    def count(_), do: {:error, __MODULE__}
    def member?(_, _), do: {:error, __MODULE__}
    def slice(_), do: {:error, __MODULE__}

    def reduce(%Shopify.Enumerable{}, {:halt, acc}, _fun), do: {:halted, acc}

    def reduce(%Shopify.Enumerable{} = enum, {:suspend, acc}, fun) do
      {:suspended, acc, &reduce(enum, &1, fun)}
    end

    def reduce(%Shopify.Enumerable{data: [], params: nil}, {:cont, acc}, _fun) do
      {:done, acc}
    end

    def reduce(%Shopify.Enumerable{data: []} = enum, {:cont, acc}, fun) do
      case enum.middleware.(fn -> enum.func.(enum.session, enum.params) end) do
        {:ok, %Response{data: data} = resp} ->
          reduce(
            %{enum | data: data, params: Pagination.next_page_params(resp)},
            {:cont, acc},
            fun
          )

        {:error, %Error{} = error} ->
          raise error
      end
    end

    def reduce(%Shopify.Enumerable{data: [head | tail]} = enum, {:cont, acc}, fun) do
      reduce(%{enum | data: tail}, fun.(head, acc), fun)
    end
  end
end
