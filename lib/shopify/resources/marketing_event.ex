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
end
