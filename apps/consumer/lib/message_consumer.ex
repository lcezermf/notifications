defmodule Consumer.MessageConsumer do
  use GenServer
  use AMQP

  @amqp_url Application.get_env(:consumer, :amqp_url)
  @exchange Application.get_env(:consumer, :exchange)

  # Client API

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: :consumer)
  end

  # Server API

  def init(:ok) do
    get_connection()
  end

  defp get_connection do
    case AMQP.Connection.open(@amqp_url) do
      {:ok, conn} ->
        Process.link(conn.pid)
        {:ok, channel} = AMQP.Channel.open(conn)
        {:ok, %{queue: queue_name}} = Queue.declare(channel, "")
        AMQP.Exchange.declare(channel, @exchange, :fanout)
        AMQP.Queue.bind(channel, queue_name, @exchange)
        {:ok, _consumer_tag} = AMQP.Basic.consume(channel, queue_name)
        {:ok, %{channel: channel, connection: conn, queue_name: queue_name, exchange: @exchange}}
      {:error, reason} ->
        IO.puts("Failed -> #{inspect(reason)}")
        :timer.sleep(5000)
        get_connection()
    end
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: _consumer_tag}}, channel) do
    {:noreply, channel}
  end

  # # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, channel) do
    {:stop, :normal, channel}
  end

  # # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, channel) do
    {:noreply, channel}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, channel) do
    # You might want to run payload consumption in separate Tasks in production
    consume(channel, tag, redelivered, payload)
    {:noreply, channel}
  end

  defp consume(_channel, _tag, _redelivered, payload) do
    IO.inspect(payload)

    # Need to create a PayloadHandler module with all functions overload
  end
end
