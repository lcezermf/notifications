defmodule Consumer.Messages.MessagesTest do
  use ExUnit.Case, async: true

  alias Consumer.Messages.Messages

  describe "create/1" do
    test "with valid data must create a new message" do
      params = %{content: "Some content"}

      assert {:ok, message} = Messages.create_message(params)
      assert message.content == params.content
    end

    test "with invalid data must return an error" do
      params = %{content: ""}

      {:error, _errors} = Messages.create_message(params)

      assert {:error, %Ecto.Changeset{}} = Messages.create_message(params)
    end
  end
end
