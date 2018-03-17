defmodule Shopify.Adapters.Base do
  @moduledoc ~S"""
  Specification of the..
  """

  @type request :: %Shopify.Request{}
  @type success :: {:ok, %Shopify.Response{}}
  @type error :: {:error, %Shopify.Response{}}

  @callback get(request) :: success | error
  @callback put(request) :: success | error
  @callback post(request) :: success | error
  @callback delete(request) :: success | error
end
