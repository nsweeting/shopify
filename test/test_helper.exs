ExUnit.start()
Application.ensure_all_started(:bypass)

defmodule Fixture do
  def load(path, root, resource) do
    path = Path.expand(path, __DIR__)
    {:ok, json} = File.read(path)
    Poison.decode!(json, as: %{root => resource}) |> Map.fetch!(root)
  end
end