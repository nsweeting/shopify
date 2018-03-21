defmodule Shopify.Country do
  @derive [Poison.Encoder]
  @singular "country"
  @plural "countries"

  use Shopify.Resource,
    import: [
      :find,
      :all,
      :count,
      :create,
      :update,
      :delete
    ]

  defstruct [
    :code,
    :id,
    :name,
    :provinces,
    :tax
  ]

  alias Shopify.Country.Province

  @doc false
  def empty_resource do
    %__MODULE__{
      provinces: [%Province{}]
    }
  end

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end
