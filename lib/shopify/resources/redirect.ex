defmodule Shopify.Redirect do
  @derive [Poison.Encoder]
  @singular "redirect"
  @plural "redirects"

  use Shopify.Resource,
    import: [
      :find,
      :all,
      :count,
      :create,
      :update,
      :delete
    ]

  alias Shopify.{
    Redirect
  }

  defstruct [
    :id,
    :path,
    :target
  ]

  @doc false
  def empty_resource do
    %Redirect{}
  end

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end
