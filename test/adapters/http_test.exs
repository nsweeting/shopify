defmodule Shopify.Adapters.HTTPTest do
  use ExUnit.Case, async: true

  alias Shopify.{Adapters.HTTP, Session, Request, Error, Product}

  defmodule RequestOption do
    def get(%Request{opts: opts}) do
      opts
    end
  end

  test "it handles httpoison errors" do
    result = {:error, %HTTPoison.Error{id: nil, reason: :econnrefused}}

    assert {:error, %Error{} = error} = HTTP.handle_response(result, %Product{})
    assert error.source == :httpoison
    assert error.reason == :econnrefused
  end

  test "it will receive session req_opts" do
    request =
      Session.new()
      |> Session.put_req_opt(:recv_timeout, 0)
      |> Request.new("/", %{}, Product)

    assert [recv_timeout: 0] = RequestOption.get(request)

    request =
      Session.new()
      |> Session.put_req_opt(:timeout, 0)
      |> Request.new("/", %{}, Product)

    assert [timeout: 0] = RequestOption.get(request)
  end
end
