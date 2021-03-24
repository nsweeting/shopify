defmodule Shopify.Adapters.HTTPTest do
  use ExUnit.Case, async: true

  alias Shopify.{Adapters.HTTP, Session, Request, Response, Error, Product}

  defmodule RequestOption do
    def get(%Request{opts: opts}) do
      opts
    end
  end

  test "it returns correct Response struct" do
    result =
      {:ok,
       %HTTPoison.Response{
         body: "{\"product\":{\"id\":123}}",
         headers: [{"X-Shopify-Shop-Api-Call-Limit", "1/80"}],
         status_code: 200
       }}

    assert {:ok, %Response{} = response} =
             HTTP.handle_response(result, %{"product" => %Product{}})

    assert response.code == 200
    assert response.data == %Product{id: 123}
    assert response.headers == [{"X-Shopify-Shop-Api-Call-Limit", "1/80"}]
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
