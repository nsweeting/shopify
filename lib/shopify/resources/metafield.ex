defmodule Shopify.Metafield do
  @moduledoc false

  @derive [Poison.Encoder]

  @singular "metafield"
  @plural "metafields"

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
    Metafield
  }

  defstruct [
    :created_at,
    :description,
    :id,
    :key,
    :namespace,
    :owner_id,
    :owner_resource,
    :value,
    :value_type,
    :updated_at
  ]

  @doc false
  def empty_resource do
    %Metafield{
      key: "",
      value: "",
      value_type: "string",
      namespace: ""
    }
  end

  ~w(blogs collections customers draft_orders orders pages products)
  |> Enum.each(fn (name) ->
    def unquote(:"#{name}")(session, parent_id, params \\ %{}) do
      session
      |> Request.new(metafield_url(unquote(name), parent_id), params, plural_resource())
      |> Client.get()
    end
  end)

  [["blogs", "articles"], ["products", "variants"]]
  |> Enum.each(fn ([parent_name, child_name]) ->
    def unquote(:"#{child_name}")(session, parent_id, child_id, params \\ %{}) do
      session
      |> Request.new(metafield_url(unquote(parent_name), parent_id,unquote(child_name), child_id), params, plural_resource())
      |> Client.get()
    end
  end)

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"

  @doc false
  def metafield_url(parent_name, parent_id) do
    parent_name <> "/#{parent_id}/" <> @plural <> ".json"
  end

  @doc false
  def metafield_url(parent_name, parent_id, child_name, child_id) do
    parent_name <> "/#{parent_id}/" <> child_name <> "/#{child_id}/" <> @plural <> ".json"
  end
end
