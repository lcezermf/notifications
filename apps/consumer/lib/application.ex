defmodule Consumer.Application do
  use Application
  alias Consumer.MessageConsumer

  def start(_type, _args) do
    children = [MessageConsumer]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
