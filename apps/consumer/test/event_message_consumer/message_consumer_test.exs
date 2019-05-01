defmodule Consumer.EventMessageConsumer.MessageConsumerTest do
  use ExUnit.Case, async: false
  import Mock

  alias Consumer.EventMessageConsumer.MessageConsumer

  setup do
    pid = case MessageConsumer.start_link do
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

      assert {:error, {:already_started, _pid}} = MessageConsumer.start_link()
    end

    test "returns connection info" do
      assert {:ok,
        %{
          channel: %AMQP.Channel{conn: %AMQP.Connection{pid: _}},
          connection: %AMQP.Connection{pid: _},
          queue_name: _queue_name,
          exchange: "send_message_exchange"
        }
      } = MessageConsumer.init(:ok)
    end
  end

  describe "handle_info" do
    test "basic_consume_ok", %{pid: pid} do
      channel = :sys.get_state(pid)

      assert {:noreply, channel} =
        MessageConsumer.handle_info({:basic_consume_ok, %{consumer_tag: 1}}, channel)
    end

    test "basic_cancel", %{pid: pid} do
      channel = :sys.get_state(pid)

      assert {:stop, :normal, channel} =
        MessageConsumer.handle_info({:basic_cancel, %{consumer_tag: 2}}, channel)
    end

    test "basic_cancel_pl", %{pid: pid} do
      channel = :sys.get_state(pid)

      assert {:noreply, channel} =
        MessageConsumer.handle_info({:basic_cancel_ok, %{consumer_tag: 3}}, channel)
    end
  end
end
