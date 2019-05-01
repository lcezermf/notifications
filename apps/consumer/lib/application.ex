defmodule Consumer.Application do
  use Application
  alias Consumer.Repo
  alias Consumer.EventMessageConsumer.MessageConsumer

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Repo, []),
      MessageConsumer
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
