use Mix.Config

config :shopify, [
  client_adapter: Shopify.Adapters.Mock,
  shop_name: "test",
  api_key: "test",
  password: "test"
]