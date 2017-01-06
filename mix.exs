defmodule Shopify.Mixfile do
  use Mix.Project

  def project do
    [app: :shopify,
     version: "0.1.0",
     elixir: "~> 1.4-rc",
     description: description(),
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      mod: {Shopify, []},
      extra_applications: [
        :logger
      ]
    ]
  end

  defp description do
    """
    An Elixir Shopify API client. Work in progress.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Nicholas Sweeting"],
      licenses: ["MIT"],
      links:  %{"GitHub" => "https://github.com/nsweeting/shopify"}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.10.0"},
      {:poison, "~> 3.0"},
      {:poolboy, "~> 1.5.1"}
    ]
  end
end
