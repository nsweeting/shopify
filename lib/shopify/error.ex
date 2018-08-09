defmodule Shopify.Error do
  defexception reason: nil, source: nil
  @type t :: %__MODULE__{source: atom | nil, reason: any}

  def message(%__MODULE__{reason: reason, source: nil}), do: inspect(reason)
  def message(%__MODULE__{reason: reason, source: source}), do: "[#{source}] - #{inspect(reason)}"
end
