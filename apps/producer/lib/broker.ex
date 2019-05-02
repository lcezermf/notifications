defmodule Producer.Broker do
  use GenServer
  use AMQP

  @amqp_url Application.get_env(:producer, :amqp_url)
  @exchange Application.get_env(:producer, :exchange)

  # Client API

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: :producer)
  end

  def publish(message) do
    GenServer.cast(:producer, {:publish_message, message})
  end

  # Server callbacks

  def init(:ok) do
    get_connection()
  end

  defp get_connection do
    case AMQP.Connection.open(@amqp_url) do
      {:ok, conn} ->
        Process.link(conn.pid)
        {:ok, channel} = AMQP.Channel.open(conn)
        # TODO: Use a different type of exchange
        Exchange.declare(channel, @exchange, :fanout)
        {:ok, %{channel: channel, connection: conn, exchange: @exchange}}
      {:error, reason} ->
        IO.puts("Failed -> #{inspect(reason)}")
        :timer.sleep(5000)
        get_connection()
    end
  end

  def handle_cast({:publish_message, message}, state) do
    {:ok, encoded_message} = Poison.encode(message)

    Basic.publish(state.channel, state.exchange, "", encoded_message)
    {:noreply, state}
  end
end
