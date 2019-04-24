defmodule Consumer.ConsumerTest do
  use ExUnit.Case, async: false
  import Mock

  alias Consumer.Consumer

  setup do
    pid = case Consumer.start_link do
      {:error, {:already_started, pid}} -> pid
      {:ok, pid} -> pid
    end

    {:ok, pid: pid}
  end

  describe "init" do
    test "must init the consumer", %{pid: pid} do
      assert %{
        channel: %AMQP.Channel{},
        connection: %AMQP.Connection{pid: _pid},
        queue_name: _queue_name,
        exchange: "send_message_exchange"
      } = :sys.get_state(pid)

      assert {:error, {:already_started, _pid}} = Consumer.start_link()
    end

    test "must return connection info" do

    end
  end
end
