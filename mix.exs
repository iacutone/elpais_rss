defmodule ElpaisRss.MixProject do
  use Mix.Project

  def project do
    [
      app: :elpais_rss,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ElpaisRss.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:castore, "~> 1.0"},
      {:ex_aws, "~> 2.0"},
      {:ex_aws_ses, "~> 2.0"},
      {:feeder_ex, git: "https://github.com/KristerV/feeder_ex.git"},
      {:jason, "~> 1.4"},
      {:req, "~> 0.7.1"},
      {:readability, "~> 0.12"}
    ]
  end
end
