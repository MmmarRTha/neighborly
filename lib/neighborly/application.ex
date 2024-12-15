defmodule Neighborly.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NeighborlyWeb.Telemetry,
      Neighborly.Repo,
      {DNSCluster, query: Application.get_env(:neighborly, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Neighborly.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Neighborly.Finch},
      # Start a worker by calling: Neighborly.Worker.start_link(arg)
      # {Neighborly.Worker, arg},
      # Start to serve requests, typically the last entry
      NeighborlyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Neighborly.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NeighborlyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
