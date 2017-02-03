defmodule Shopify.ApplicationCredit do
  @derive [Poison.Encoder]
  @singular "application_credit"
  @plural "application_credits"
  
  use Shopify.Resource, import: [
    :find,
    :all,
    :create
  ]

  alias Shopify.{
    ApplicationCredit
  }

  defstruct [
    :description,
    :id,
    :amount,
    :test
  ]

  @doc false
  def empty_resource do
    %ApplicationCredit{}
  end

  @doc false
  def find_url(id), do: @plural <>  "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"
end