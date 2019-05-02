defmodule Consumer.EventMessageConsumer.PayloadHandlerTest do
  use ExUnit.Case, async: false
  alias Consumer.EventMessageConsumer.PayloadHandler

  describe "handle/1" do
    test "with valid event and valid data" do
      {:ok, payload} = Poison.encode(%{event: "CREATE_MESSAGE", data: %{content: "Some data"}})

      assert :ok = PayloadHandler.handle(payload)
    end

    test "with valid other event and valid data" do
      {:ok, payload} = Poison.encode(%{event: "CREATE_SIMPLE_MESSAGE", data: %{content: "Some data"}})

      assert :ok = PayloadHandler.handle(payload)
    end

    test "with invalid event and no data" do
      {:ok, payload} = Poison.encode(%{event: "SOME_EVENT", data: nil})

      assert :reject = PayloadHandler.handle(payload)
    end

    test "with invalid event and data" do
      {:ok, payload} = Poison.encode(%{event: "SOME_EVENT", data: "data"})

      assert :reject = PayloadHandler.handle(payload)
    end
  end
end
