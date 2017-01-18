defmodule Shopify.RecurringApplicationCharge  do
  @derive[Poison.Encoder]
  @singular "recurring_application_charge"
  @plural "recurring_application_charges"

  use Shopify.Resource, import: [:find, :all, :create, :delete]

  alias Shopify.{Client, Request, RecurringApplicationCharge}

  defstruct [
    :activated_on,
    :billing_on,
    :cancelled_on,
    :capped_amount,
    :confirmation_url,
    :created_at,
    :id,
    :name,
    :price,
    :return_url,
    :status,
    :terms,
    :test,
    :trial_days,
    :trial_ends_on,
    :updated_at
  ]

  @doc """
  Requests to activate the reucrring charge.

  Returns `{:ok, resource}` or `{:error, %Shopify.Error{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - id: The id of the resource.
    
  ## Examples
      iex> Shopify.session |> Shopify.RecurringApplicationCharge.activate(id)
      {:ok, %Shopify.RecurringApplicationCharge{}}
  """
  def activate(session, id) do
    session
      |> Request.new(activate_url(id), %{}, singular_resource())
      |> Client.post
  end

  @doc false
  def empty_resource do
    %RecurringApplicationCharge{}
  end

  @doc false
  def find_url(id), do: @plural <>  "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def activate_url(id), do: @plural <>  "/#{id}/activate.json"
end