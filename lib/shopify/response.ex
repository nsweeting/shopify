defmodule Shopify.Response do
  @moduledoc false

  alias Shopify.Response

  defstruct [
    :code,
    :data
  ]

  def new(code, body, resource) when code < 300 do
    {:ok, %Response{code: code, data: resource |> parse_json(body)}}
  end

  def new(code, body, error) do
    {:error, %Response{code: code, data: error |> parse_json(body)}}
  end

  defp parse_json(_, nil) do
    nil
  end

  defp parse_json(resource, body) do
    case Poison.decode(body, as: resource) do
      {:ok, %Shopify.OAuth{} = oauth} -> oauth
      {:ok, resource} -> parse_resource(resource)
      {:error, _} -> nil
    end
  end

  defp parse_resource(resource)
  defp parse_resource(%{__struct__: _} = resource), do: resource
  defp parse_resource(resource), do: resource |> Map.values() |> List.first()
end
