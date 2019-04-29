defmodule Consumer.PayloadHandlerTest do
  use ExUnit.Case, async: false
  import Mock

  alias Consumer.PayloadHandler

  describe "handle/1" do
    test "must handle payload with %{event: \"CREATE_SIMPLE_MESSAGE\", data: \"some message\"}" do
      payload = %{event: "CREATE_SIMPLE_MESSAGE", data: "Some data"}

      assert :ok = PayloadHandler.handle(payload)
    end
  end
end
