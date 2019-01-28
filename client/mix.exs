defmodule Client.MixProject do
  use Mix.Project

  def project do
    [
      app: :client,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      included_applications: [:tictac],
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      { :tictac, path: "../tictac" }
    ]
  end
end
