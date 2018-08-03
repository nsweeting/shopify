defmodule Shopify.Adapters.HTTPTest do
  use ExUnit.Case, async: true

  alias Shopify.{Adapters.HTTP, Session, Request, Error, Product}

  test "it handles httpoison errors" do
    result = {:error, %HTTPoison.Error{id: nil, reason: :econnrefused}}

    assert {:error, %Error{} = error} = HTTP.handle_response(result, %Product{})
    assert error.source == :httpoison
    assert error.reason == :econnrefused
  end

  test "it will use session req_opts" do
    request =
      Session.new()
      |> Session.put_req_opt(:recv_timeout, 0)
      |> Request.new("/", %{}, Product)

    assert {:error, %Error{} = error} = HTTP.get(request)
    assert error.source == :httpoison
    assert error.reason == :timeout

    request =
      Session.new()
      |> Session.put_req_opt(:timeout, 0)
      |> Request.new("/", %{}, Product)

    assert {:error, %Error{} = error} = HTTP.get(request)
    assert error.source == :httpoison
    assert error.reason == :connect_timeout
  end
end
