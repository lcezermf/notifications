defmodule Producer.BrokerTest do
  use ExUnit.Case, async: false
  # import Mock

  alias Producer.Broker

  setup do
    pid = case Broker.start_link do
      {:error, {:already_started, pid}} -> pid
      {:ok, pid} -> pid
    end

    {:ok, pid: pid}
  end

  describe "init" do
    test "must init the message broker", %{pid: pid} do
      assert %{
        channel: %AMQP.Channel{},
        connection: %AMQP.Connection{pid: _pid},
        exchange: _
      } = :sys.get_state(pid)

      assert {:error, {:already_started, _pid}} = Broker.start_link()
    end
  end
end
