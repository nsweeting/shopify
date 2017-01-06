defmodule Shopify do
  use Application
  
  alias Shopify.Config

  def start(_type, _args) do
    pool_config = [
      name: {:local, Config.pool_name()},
      worker_module: Shopify.Worker,
      size: Config.get(:pool_size, 10),
      max_overflow: Config.get(:pool_max_overflow, 1)
    ]

    Shopify.Supervisor.start_link(pool_config)
  end

  def session(type, config), do: Shopify.Session.new(type, config)
  def session, do: Shopify.Session.new
end