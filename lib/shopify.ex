defmodule Shopify do
  def session(type, config), do: Shopify.Session.new(type, config)
  def session, do: Shopify.Session.new
end