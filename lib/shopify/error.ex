defmodule Shopify.Error do
  @moduledoc false
  
  alias Shopify.Error

  defstruct [
    :code,
    :reason
  ]

  def from_response(%HTTPoison.Response{status_code: code, body: body}) do
    case Poison.Parser.parse(body) do
      {:ok, %{"errors" => error}} -> {:error, %Error{code: code, reason: error}}
      {:error, _} -> {:error, %Error{code: code, reason: nil}}
    end
  end
end