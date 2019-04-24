defmodule Consumer.Application do
  use Application
  alias Consumer.Consumer

  def start(_type, _args) do
    children = [Consumer]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
