ExUnit.start()

defmodule Fixture do
  def load(path, root, resource) do
    {:ok, json} = load_json(path)
    Poison.decode!(json, as: %{root => resource}) |> Map.fetch!(root)
  end

  def load(path, resource) do
    {:ok, json} = load_json(path)
    Poison.decode!(json, as: resource)
  end

  defp load_json(path) do
    Path.expand(path, __DIR__)
    |> File.read()
  end
end
