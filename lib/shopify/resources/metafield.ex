defmodule Shopify.Metafield do
  @moduledoc false

  @derive [Poison.Encoder]

  @singular "metafield"
  @plural "metafields"

  @plural_to_singular %{
    "blogs"        => "blog",
    "collections"  => "collection",
    "customers"    => "customer",
    "draft_orders" => "draft_order",
    "orders"       => "order",
    "pages"        => "page",
    "products"     => "product",
    "variants"     => "variant",
    "articles"     => "article"
  }

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
    singular_name = @plural_to_singular[name]
    def unquote(:"all_#{singular_name}_metafields")(session, parent_id, params \\ %{}) do
      session
      |> Request.new(metafields_url_for_object(unquote(name), parent_id), params, plural_resource())
      |> Client.get()
    end

    def unquote(:"find_#{singular_name}_metafield")(session, parent_id, metafield_id) do
      session
      |> Request.new(metafield_url_for_object(unquote(name), parent_id, metafield_id), %{}, singular_resource())
      |> Client.get()
    end

    def unquote(:"count_#{singular_name}_metafields")(session, parent_id) do
      session
      |> Request.new(metafield_url_for_object(unquote(name), parent_id, 'count'), %{}, nil)
      |> Client.get()
    end

    def unquote(:"create_#{singular_name}_metafield")(session, parent_id, new_resource) do
      body = new_resource |> to_json

      session
      |> Request.new(metafields_url_for_object(unquote(name), parent_id), %{}, singular_resource(), body)
      |> Client.post()
    end

    def unquote(:"update_#{singular_name}_metafield")(session, parent_id, metafield_id, updated_resource) do
      body = updated_resource |> to_json

      session
      |> Request.new(metafield_url_for_object(unquote(name), parent_id, metafield_id), %{}, singular_resource(), body)
      |> Client.put()
    end

    def unquote(:"delete_#{singular_name}_metafield")(session, parent_id, metafield_id) do
      session
      |> Request.new(metafield_url_for_object(unquote(name), parent_id, metafield_id), %{}, nil)
      |> Client.delete()
    end
  end)

  [["blogs", "articles"], ["products", "variants"]]
  |> Enum.each(fn ([parent_name, child_name]) ->
    singular_name = "#{@plural_to_singular[parent_name]}_#{@plural_to_singular[child_name]}"
    def unquote(:"all_#{singular_name}_metafields")(session, parent_id, child_id, params \\ %{}) do
      session
      |> Request.new(metafields_url_for_object(unquote(parent_name), parent_id, unquote(child_name), child_id), params, plural_resource())
      |> Client.get()
    end

    def unquote(:"find_#{singular_name}_metafield")(session, parent_id, child_id, metafield_id) do
      session
      |> Request.new(metafield_url_for_object(unquote(parent_name), parent_id, unquote(child_name), child_id, metafield_id), %{}, singular_resource())
      |> Client.get()
    end

    def unquote(:"count_#{singular_name}_metafields")(session, parent_id, child_id) do
      session
      |> Request.new(metafield_url_for_object(unquote(parent_name), parent_id, unquote(child_name), child_id, 'count'), %{}, nil)
      |> Client.get()
    end

    def unquote(:"create_#{singular_name}_metafield")(session, parent_id, child_id, new_resource) do
      body = new_resource |> to_json

      session
      |> Request.new(metafields_url_for_object(unquote(parent_name), parent_id, unquote(child_name), child_id), %{}, singular_resource(), body)
      |> Client.post()
    end

    def unquote(:"update_#{singular_name}_metafield")(session, parent_id, child_id, metafield_id, updated_resource) do
      body = updated_resource |> to_json

      session
      |> Request.new(metafield_url_for_object(unquote(parent_name), parent_id, unquote(child_name), child_id, metafield_id), %{}, singular_resource(), body)
      |> Client.put()
    end

    def unquote(:"delete_#{singular_name}_metafield")(session, parent_id, child_id, metafield_id) do
      session
      |> Request.new(metafield_url_for_object(unquote(parent_name), parent_id, unquote(child_name), child_id, metafield_id), %{}, nil)
      |> Client.delete()
    end
  end)

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"

  @doc false
  defp metafields_url_for_object(parent_name, parent_id) do
    parent_name <> "/#{parent_id}/" <> @plural <> ".json"
  end

  @doc false
  defp metafields_url_for_object(parent_name, parent_id, child_name, child_id) do
    parent_name <> "/#{parent_id}/" <> child_name <> "/#{child_id}/" <> @plural <> ".json"
  end

  @doc false
  defp metafield_url_for_object(parent_name, parent_id, metafield_id) do
    parent_name <> "/#{parent_id}/" <> @plural <> "/#{metafield_id}.json"
  end

  @doc false
  defp metafield_url_for_object(parent_name, parent_id, child_name, child_id, metafield_id) do
    parent_name <> "/#{parent_id}/" <> child_name <> "/#{child_id}/" <> @plural <> "/#{metafield_id}.json"
  end
end
