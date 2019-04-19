defmodule Producer.Broker do
  use GenServer
  use AMQP

  @amqp_url Application.get_env(:producer, :amqp_url)
  @exchange Application.get_env(:producer, :exchange)

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: :producer)
  end

  def init(:ok) do
    get_connection()
  end

  defp get_connection do
    case AMQP.Connection.open(@amqp_url) do
      {:ok, conn} ->
        Process.link(conn.pid)
        {:ok, channel} = AMQP.Channel.open(conn)
        Exchange.declare(channel, @exchange, :fanout)
        {:ok, %{channel: channel, connection: conn, exchange: @exchange}}
      {:error, reason} ->
        IO.puts("Failed -> #{inspect(reason)}")
        :timer.sleep(5000)
        get_connection()
    end
  end
end
