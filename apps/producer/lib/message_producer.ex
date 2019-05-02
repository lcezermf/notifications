defmodule Producer.MessageProducer do
  alias Producer.Broker

  def publish(message) do
    payload = %{event: "CREATE_MESSAGE", data: %{content: message}}

    Broker.publish(payload)
  end
end
