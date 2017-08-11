defmodule Calendar.ESpec.Mixfile do
  use Mix.Project

  def project do
    [
      app: :calendar_espec,
      name: "Calendar ESpec",
      version: "0.1.0",
      elixir: ">= 1.3.4",
      package: package(),
      deps: deps(),
      source_url: "https://github.com/bozydar/calendar_espec",
      preferred_cli_env: [espec: :test]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:espec, ">= 1.3.3"}
    ]
  end

  defp package do
    [
      files: ~w(lib mix.exs README.md),
      maintainers: ["Bozydar Sobczak"],
      licenses: ["MIT"],
      links: %{"github" => "https://github.com/bozydar/calendar_espec"}
     ]
  end
end
