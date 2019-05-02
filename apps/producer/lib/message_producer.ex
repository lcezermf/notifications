defmodule Producer.MessageProducer do
  alias Producer.Broker

  def publish_message(message) do
    payload = %{event: "CREATE_MESSAGE", data: %{content: message}}

    Broker.publish(payload)
  end

  def publish_simple_message(message) do
    payload = %{event: "CREATE_SIMPLE_MESSAGE", data: %{content: message}}

    Broker.publish(payload)
  end
end
