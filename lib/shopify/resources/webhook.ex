defmodule Shopify.Webhook do
  @derive[Poison.Encoder]
  @singular "webhook"
  @plural "webhooks"

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
    Webhook,
    Config
  }

  defstruct [
    :address,
    :api_version,
    :created_at,
    :fields,
    :format,
    :id,
    :metafield_namespaces,
    :topic,
    :updated_at
  ]

  @doc """
  Authenticates an incoming webhook using the client secret.

  Returns `true` or `false`

  ## Parameters
    - hmac: The value held in the 'X-Shopify-Hmac-SHA256' header.
    - body: The body of the webhook.
    
  ## Examples
      iex> Shopify.Webhook.authenticate(hmac, body)
      true
      
  """
  def authenticate(hmac, body) when is_binary(hmac) and is_binary(body) do
    :crypto.hmac(:sha256, Config.get(:client_secret), body)
    |> Base.encode64()
    |> String.equivalent?(hmac)
  end

  @doc false
  def authenticate(_, _), do: false

  @doc false
  def empty_resource do
    %Webhook{}
  end

  @doc false
  def find_url(id), do: @plural <> "/#{id}.json"

  @doc false
  def all_url, do: @plural <> ".json"

  @doc false
  def count_url, do: @plural <> "/count.json"
end
