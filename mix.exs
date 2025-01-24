defmodule ElpaisRss.MixProject do
  use Mix.Project

  def project do
    [
      app: :elpais_rss,
      version: "0.1.0",
      elixir: "~> 1.18",
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
      {:ex_aws, "~> 2.0"},
      {:ex_aws_ses, "~> 2.0"},
      {:feeder_ex, git: "https://github.com/KristerV/feeder_ex.git"},
      {:google_api_translate, "~> 0.21.0"},
      {:goth, "~> 1.4.0"},
      {:jason, "~> 1.4"},
      {:quantum, "~> 3.0"},
      {:readability, "~> 0.12"}
    ]
  end
end
