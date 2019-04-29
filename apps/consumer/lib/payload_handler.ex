defmodule Consumer.PayloadHandler do
  def handle(%{event: "CREATE_SIMPLE_MESSAGE", data: data}) do
    :ok
  end
end
