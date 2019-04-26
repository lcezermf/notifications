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

    test "returns connection info" do
      assert {:ok,
        %{
          channel: %AMQP.Channel{conn: %AMQP.Connection{pid: _}},
          connection: %AMQP.Connection{pid: _},
          queue_name: _queue_name,
          exchange: "send_message_exchange"
        }
      } = Consumer.init(:ok)
    end
  end

  describe "handle_info" do
    test "basic_consume_ok", %{pid: pid} do
      channel = :sys.get_state(pid)

      assert {:noreply, channel} ==
        Consumer.handle_info({:basic_consume_ok, %{consumer_tag: 1}}, channel)
    end
  end
end
