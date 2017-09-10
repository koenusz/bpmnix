defmodule Bpmnix.Mixfile do
  use Mix.Project

  def project do
    [app: :bpmnix,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     elixirc_paths: elixirc_paths(Mix.env),
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger],
    mod: {BPMnix, []}
  ]
  end

  defp elixirc_paths :test do
    ["lib", "test/support"]
  end

  defp elixirc_paths :dev do
    ["lib", "test/support"]
  end

  defp elixirc_paths _ do
    ["lib"]
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
    [ {:sweet_xml, "~> 0.6.5"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false} ]
  end

  defp aliases do
  [
    test: "test --no-start"
  ]
  end
end
