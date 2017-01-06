defmodule Shopify.Worker do
  use GenServer
  alias Shopify.Config

  def start_link(_state) do
    GenServer.start_link(__MODULE__, [], [])
  end

  def perform(call) do
    :poolboy.transaction(Config.pool_name(), fn(worker) ->
      GenServer.call(worker, call)
    end, Config.timeout())
  end

  @doc false
  def handle_call([module, request], _, _) do
    {:reply, module.request(request), []}
  end
end