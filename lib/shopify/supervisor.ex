defmodule Shopify.Supervisor do
  use Supervisor
  alias Shopify.Config

  def start_link(pool_config) do
    Supervisor.start_link(__MODULE__, pool_config, name: __MODULE__)
  end

  def init(pool_config) do
    options = [
      strategy: :one_for_one,
    ]

    children = [
      :poolboy.child_spec(Config.pool_name(), pool_config, [])
    ]

    supervise(children, options)
  end
end