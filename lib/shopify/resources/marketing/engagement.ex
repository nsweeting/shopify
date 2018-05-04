defmodule Shopify.MarketingEvent.Engagement do
  @plural "engagements"
  @singular "engagement"

  use Shopify.NestedResource

  defstruct [
    :occurred_on,
    :impressions_count,
    :views_count,
    :clicks_count,
    :shares_count,
    :favorites_count,
    :comments_count ,
    :ad_spend,
    :is_cumulative,
  ]

  @doc false
  def empty_resource, do: %__MODULE__{}

  @doc """
  Creates multiple engagements.

  Returns `{:ok, %Shopify.Response{}}` or `{:error, %Shopify.Response{}}`

  ## Parameters
    - session: A `%Shopify.Session{}` struct.
    - marketing_event_id: The id of the marketing event.
    - engagements: A `Shopify.MarketingEvent.Engagement{}` struct.

  ## Examples
      iex> Shopify.session |> Shopify.MarketingEvent.Engagement.create_multiple(1, [%Shopify.MarketingEvent.Engagement{occurred_on: "2018-12-01"}])
      {:ok, %Shopify.Response{}}
  """
  @spec create_multiple(%Shopify.Session{}, integer, list(%__MODULE__{})) :: %Shopify.Response{}
  def create_multiple(%Shopify.Session{} = session, marketing_event_id, engagements) do
    body = engagements |> to_json()

    url = "marketing_events/#{marketing_event_id}/" <> @plural <> ".json"
    session
    |> Request.new(url, %{}, %{"engagements" => [empty_resource()]}, body)
    |> Client.post()
  end
end
