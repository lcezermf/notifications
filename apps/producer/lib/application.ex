defmodule Producer.Application do
  use Application
  alias Producer.Broker

  def start(_type, _args) do
    children = [Broker]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
