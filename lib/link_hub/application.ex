defmodule LinkHub.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LinkHubWeb.Telemetry,
      LinkHub.Repo,
      {DNSCluster, query: Application.get_env(:link_hub, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LinkHub.PubSub},
      # Start a worker by calling: LinkHub.Worker.start_link(arg)
      # {LinkHub.Worker, arg},
      # Start to serve requests, typically the last entry
      LinkHubWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LinkHub.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LinkHubWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
