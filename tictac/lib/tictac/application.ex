defmodule Tictac.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      worker(Tictac.Server, [])
    ]

    options = [
      name: Tictacs.Supervisor,
      strategy: :simple_one_for_one,
    ]

    Supervisor.start_link(children, options)
  end
end
