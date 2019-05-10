defmodule Shopify.ResourceTest do
  use ExUnit.Case, async: true

  describe "Shopify.Resource" do
    defmodule Dummy do
      @singular "dummy"
      @plural "dummies"

      use Shopify.Resource,
        import: [
          :create,
          :update
        ]

      defstruct [:id, :name]

      def empty_resource, do: %__MODULE__{}

      @doc false
      def find_url(id), do: @plural <> "/#{id}.json"

      @doc false
      def all_url, do: @plural <> ".json"
    end

    test "create/3 works with a map as resource argument" do
      args = %{name: "Dummy!"}

      assert {:ok, response} = Shopify.session() |> Dummy.create(args)
      assert %Shopify.Response{} = response
      assert 200 == response.code

      assert %Dummy{} = response.data
    end

    test "update/3 works with a map as resource argument" do
      assert {:ok, response} = Shopify.session() |> Dummy.update(1, %{name: "Update"})
      assert "Update" == response.data.name
    end
  end

  describe "Shopify.NestedResource" do
    defmodule Dummy.NestedDummy do
      @singular "nested_dummy"
      @plural "nested_dummies"

      use Shopify.NestedResource,
        import: [
          :create,
          :update
        ]

      defstruct [:id, :name_2]

      @doc false
      def empty_resource, do: %__MODULE__{}

      @doc false
      def find_url(top_id, nest_id), do: base_url(top_id) <> "/#{nest_id}.json"

      @doc false
      def all_url(top_id), do: base_url(top_id) <> ".json"

      defp base_url(top_id), do: "dummies/#{top_id}/" <> @plural
    end

    test "create/4 works with a map as resource argument" do
      args = %{name_2: "Dummy!"}

      assert {:ok, response} = Shopify.session() |> Dummy.NestedDummy.create(1, args)
      assert %Shopify.Response{} = response
      assert 200 == response.code

      assert %Dummy.NestedDummy{} = response.data
    end

    test "update/4 works with a map as resource argument" do
      assert {:ok, response} =
               Shopify.session() |> Dummy.NestedDummy.update(1, 2, %{name_2: "Update"})

      assert "Update" == response.data.name_2
    end
  end
end
