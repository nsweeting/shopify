defmodule Shopify.Adapters.Base do
  @moduledoc ~S"""
  Specification of the adapter used to load resources.
  Other than from the real Shopify API you could load from fixtures, or from your own mock API.
  """

  @type success :: {:ok, Shopify.Response.t()}
  @type error :: {:error, Shopify.Response.t()}

  @callback get(Shopify.Request.t()) :: success | error
  @callback put(Shopify.Request.t()) :: success | error
  @callback post(Shopify.Request.t()) :: success | error
  @callback delete(Shopify.Request.t()) :: success | error
end
