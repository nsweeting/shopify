defmodule Shopify.Response do
  @moduledoc false

  alias Shopify.Response

  defstruct [
    :code,
    :data
  ]

  def new(code, body, resource) when code < 300 do
    {:ok,  %Response{code: code, data: resource |> parse_json(body)}}
  end

  def new(code, body, _) do
    {:error,  %Response{code: code, data: nil |> parse_json(body)}}
  end

  defp parse_json(_, nil) do
    nil
  end

  defp parse_json(resource, body) do
    case Poison.decode(body, as: resource) do
      {:ok, resource} -> resource |> Map.values |> List.first
      {:error, _} -> nil
    end
  end
end