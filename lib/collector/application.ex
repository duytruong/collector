defmodule Collector.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  
  defp poolboy_config do
    [{:name, {:local, :kafka_workers}},
     {:worker_module, Collector.Worker},
     {:size, 500},
     {:max_overflow, 0}]
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Collector.Worker.start_link(arg1, arg2, arg3)
      # worker(Collector.Worker, [arg1, arg2, arg3]),
      #worker(Collector.Worker, []),
      Plug.Adapters.Cowboy.child_spec(:http, Collector.Router, [], port: 4000),
      :poolboy.child_spec(:kafka_workers, poolboy_config(), []),
      worker(Collector.AvroEncoder, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Collector.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
