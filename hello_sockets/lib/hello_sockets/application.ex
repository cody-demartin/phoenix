defmodule HelloSockets.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias HelloSockets.Pipeline.Producer
  alias HelloSockets.Pipeline.ConsumerSupervisor, as: Consumer

  def start(_type, _args) do
    :ok = HelloSockets.Statix.connect()

    children = [
      # Start the Telemetry supervisor
      HelloSocketsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: HelloSockets.PubSub},
      # Start the Endpoint (http/https)

      # adding before endpoint because want pipeline to be available before
      # web endpoints are

      # if we added after "no process" errors could exist
      # min/max demand helps us configure to only process a few items at a time

      # for in memory configs, keep the amount low. if going to DB, make it
      # higher to reduce the amount of aync calls to DB
      {Producer, name: Producer},
      {Consumer, subscribe_to: [{Producer, max_demand: 10, min_demand: 5}]},
      HelloSocketsWeb.Endpoint
      # Start a worker by calling: HelloSockets.Worker.start_link(arg)
      # {HelloSockets.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloSockets.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HelloSocketsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
