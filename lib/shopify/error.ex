defmodule Shopify.Error do
  alias Shopify.Error

  defstruct [
    :code,
    :reason
  ]

  def from_response(%HTTPoison.Response{status_code: code, body: body}) do
    {:ok, %{"errors" => error}} = Poison.Parser.parse(body)
    {:error, %Error{code: code, reason: error}}
  end
end