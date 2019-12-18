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

    def reduce(%Shopify.Enumerable{} = e, {:suspend, acc}, fun) do
      {:suspended, acc, &reduce(e, &1, fun)}
    end

    def reduce(%Shopify.Enumerable{data: [], params: nil}, {:cont, acc}, _fun) do
      {:done, acc}
    end

    def reduce(%Shopify.Enumerable{data: []} = e, {:cont, acc}, fun) do
      case e.middleware.(fn -> e.func.(e.session, e.params) end) do
        {:ok, %Response{data: data} = resp} ->
          reduce(
            %{e | data: data, params: Pagination.next_page_params(resp)},
            {:cont, acc},
            fun
          )

        {:error, %Error{} = error} ->
          raise error
      end
    end

    def reduce(%Shopify.Enumerable{data: [h | t]} = e, {:cont, acc}, fun) do
      reduce(%{e | data: t}, fun.(h, acc), fun)
    end
  end
end
