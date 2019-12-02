defmodule Shopify.Response do
  @moduledoc false

  @type t :: %__MODULE__{code: integer, data: map | list(map)}

  alias Shopify.Response

  defstruct [
    :code,
    :data,
    :headers
  ]

  def new(%{body: body, code: code, headers: headers}, resource) when code < 300 do
    {:ok, %Response{code: code, data: resource |> parse_json(body), headers: headers}}
  end

  def new(%{body: body, code: code, headers: headers}, error) do
    {:error, %Response{code: code, data: error |> parse_json(body), headers: headers}}
  end

  defp parse_json(_res, body) when is_nil(body) or body == "" do
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
