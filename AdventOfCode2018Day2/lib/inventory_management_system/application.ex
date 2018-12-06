defmodule InventoryManagementSystem.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      InventoryManagementSystem.inventory_management_system
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InventoryManagementSystem.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, :ok)
  end

end
