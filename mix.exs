defmodule Issues.Mixfile do
  use Mix.Project

  def project do
    [
      app: :issues,
      escript: escript_config,
      version: "0.1.0",
      name: "Issues",
      source_url: "https://github.com/birladeanuPavel/issues",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1.0"},
      {:ex_doc, "~> 0.18.1"},
      {:earmark, "~> 1.2.4"},
      {:excoveralls, "~> 0.8.0", only: :test}
    ]
  end

  def escript_config do
    [main_module: Issues.CLI]
  end
end
