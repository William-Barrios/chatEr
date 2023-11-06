defmodule ChatEr.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ChatErWeb.Telemetry,
      ChatEr.Repo,
      {DNSCluster, query: Application.get_env(:chatEr, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ChatEr.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ChatEr.Finch},
      # Start a worker by calling: ChatEr.Worker.start_link(arg)
      # {ChatEr.Worker, arg},
      # Start to serve requests, typically the last entry
      ChatErWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChatEr.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChatErWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
