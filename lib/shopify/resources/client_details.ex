defmodule Shopify.ClientDetails do
  @derive [Poison.Encoder]

  defstruct [
    :accept_language,
    :browser_height,
    :browser_ip,
    :browser_width,
    :session_hash,
    :user_agent
  ]
end