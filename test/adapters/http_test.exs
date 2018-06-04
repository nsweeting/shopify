defmodule Shopify.Adapters.HTTPTest do
  use ExUnit.Case, async: true

  alias Shopify.{Adapters.HTTP, Error, Product}

  test "it handles httpoison errors" do
    result = {:error, %HTTPoison.Error{id: nil, reason: :econnrefused}}

    assert {:error, %Error{} = error} = HTTP.handle_response(result, %Product{})

    assert error.source == :httpoison
    assert error.reason == :econnrefused
  end
end
