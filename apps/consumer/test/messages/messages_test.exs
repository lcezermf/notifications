defmodule Consumer.Messages.MessagesTest do
  use ExUnit.Case, async: true

  alias Consumer.Messages.{Message, Messages}

  describe "create/1" do
    test "with valid data must create a new message" do
      params = %{content: "Some content"}

      assert {:ok, message} = Messages.create_message(params)
      assert message.content == params.content
    end

    # test "with valid data must craete a new category" do
    #   params = %{title: "My title"}

    #   assert {:ok, category} = Categories.create_category(params)

    #   assert category.title == params.title
    # end

    # test "with invalid data must return an error" do
    #   params = %{title: ""}

    #   {:error, changeset_errors} = Categories.create_category(params)

    #   assert "can't be blank" in errors_on(changeset_errors).title
    #   assert {:error, %Ecto.Changeset{}} = Categories.create_category(params)
    # end
  end
end
