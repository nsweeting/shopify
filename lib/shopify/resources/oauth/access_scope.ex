defmodule Shopify.OAuth.AccessScope do
  @moduledoc false

  @derive [Poison.Encoder]
  @singular "access_scope"
  @plural "access_scopes"

  use Shopify.Resource, import: [:all]

  defstruct [:handle]

  def empty_resource, do: %__MODULE__{}

  def all_url, do: "oauth/" <> @plural <> ".json"
end
