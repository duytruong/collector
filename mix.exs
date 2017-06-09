defmodule Collector.Mixfile do
  use Mix.Project

  def project do
    [app: :collector,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger],
     mod: {Collector.Application, []}]
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
    [{:plug, "~> 1.3"},
     {:cowboy, "~> 1.1"},
     {:kafka_ex, "~> 0.6.5"},
     {:poolboy, "~> 1.5"},
     {:erlavro, github: "klarna/erlavro"},
     {:distillery, "~> 1.4"}]
  end
end
