defmodule Shopify.Report do
  @singular "report"
  @plural "reports"

  defstruct [
    :id,
    :name,
    :shopify_ql,
    :updated_at,
    :category
  ]

  use Shopify.Resource,
    import: [
      :create,
      :find,
      :all,
      :update,
      :delete
    ]

  @doc false
  def empty_resource, do: %__MODULE__{}

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"
end
