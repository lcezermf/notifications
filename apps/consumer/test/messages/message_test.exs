defmodule Consumer.Messages.MessageTest do
  use ExUnit.Case, async: true

  alias Consumer.Messages.Message

  describe "validations" do
    test "content must be required" do
      message = %Message{}
      changeset = Message.changeset(message, %{})

      refute changeset.valid?
    end

    test "valid params" do
      message = %Message{content: "Some content"}
      changeset = Message.changeset(message, %{})

      assert changeset.valid?
    end
  end
end
