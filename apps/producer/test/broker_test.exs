defmodule Producer.BrokerTest do
  use ExUnit.Case, async: false
  import Mock

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
        exchange: "send_message_exchange"
      } = :sys.get_state(pid)

      assert {:error, {:already_started, _pid}} = Broker.start_link()
    end

    test "must return a connection info" do
      assert {:ok,
        %{
          channel: %AMQP.Channel{conn: %AMQP.Connection{pid: _}},
          connection: %AMQP.Connection{pid: _},
          exchange: "send_message_exchange"
        }
      } = Broker.init(:ok)
    end
  end

  describe "publish/1" do
    test "must publish a message to the given exchange" do
      this = self()
      message = %{event: "CREATE_MESSAGE", data: "my message"}
      exchange = "send_message_exchange"

      with_mock AMQP.Basic, [publish: fn(_channel, _exchange, _routing_key, _message) -> send(this, {:publish_message, message}) end] do
        Broker.publish(message)

        assert_receive {:publish_message, message}
        assert_called(AMQP.Basic.publish(:_, exchange, :_, message))
      end
    end
  end
end
