defmodule Shopify.MarketingEvent do
  @singular "marketing_event"
  @plural "marketing_events"

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
    :id,
    :remote_id,
    :event_type,
    :marketing_channel,
    :paid,
    :referring_domain,
    :budget,
    :currency,
    :budget_type,
    :started_at,
    :scheduled_to_end_at,
    :ended_at,
    :utm_campaign,
    :utm_source,
    :utm_medium,
    :utm_term,
    :utm_content,
    :description,
    :manage_url,
    :preview_url,
    :marketed_resources
  ]

  @doc false
  def empty_resource, do: %__MODULE__{marketed_resources: []}

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"

  @doc """
  Alias for `Shopify.MarketingEvent.Engagement.create_multiple/3`
  """
  @spec create_multiple_engagements(
          %Shopify.Session{},
          integer,
          list(%Shopify.MarketingEvent.Engagement{})
        ) :: {:ok, Shopify.Response.t()} | {:error, Shopify.Response.t()}
  def create_multiple_engagements(%Shopify.Session{} = session, marketing_event_id, engagements) do
    __MODULE__.Engagement.create_multiple(session, marketing_event_id, engagements)
  end
end
