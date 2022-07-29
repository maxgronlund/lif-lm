defmodule Run.MixProject do
  use Mix.Project

  def project do
    [
      app: :run,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Run.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 3.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:ecto_sql, "~> 3.6"},
      {:gettext, "~> 0.18"},
      {:hackney, "~> 1.18"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.2"},
      {:swoosh, "~> 1.3"},
      {:arc, "~> 0.11.0"},
      {:arc_ecto, "~> 0.11.3"},
      {:ex_aws, "~> 2.3"},
      {:ex_aws_s3, "~> 2.3"},
      {:poison, "~> 3.1"},
      {:sweet_xml, "~> 0.7.3"},
      {:slugify, "~> 1.3"},
      {:timex, "~> 3.7"},
      {:quantum, "~> 3.5"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
