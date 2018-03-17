defmodule Shopify.ApplicationCharge do
  @derive [Poison.Encoder]
  @singular "application_charge"
  @plural "application_charges"

  use Shopify.Resource,
    import: [
      :find,
      :all,
      :create,
      :activate
    ]

  alias Shopify.{
    ApplicationCharge
  }

  defstruct [
    :confirmation_url,
    :created_at,
    :id,
    :name,
    :price,
    :return_url,
    :status,
    :test,
    :updated_at
  ]

  @doc false
  def empty_resource do
    %ApplicationCharge{}
  end

  @doc """
  Requests to activate the application charge.

  Returns `{:ok, resource}` or `{:error, %Shopify.Error{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - id: The id of the resource.
    
  ## Examples
      iex> Shopify.session |> Shopify.ApplicationCharge.activate(id)
      {:ok, %Shopify.Response{}}
  """
  def activate(session, id) do
    session
    |> Request.new(activate_url(id), %{}, singular_resource())
    |> Client.post()
  end

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def activate_url(id), do: @plural <> "/#{id}/activate.json"
end
