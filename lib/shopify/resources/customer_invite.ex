defmodule Shopify.CustomerInvite do
  @derive [Poison.Encoder]
  @singular "customer_invite"
  @plural "customer_invites"

  use Shopify.Resource

  alias Shopify.CustomerInvite

  defstruct [
    :to,
    :from,
    :subject,
    :custom_message,
    :bcc
  ]

  @doc false
  def empty_resource do
    %CustomerInvite{}
  end
end
