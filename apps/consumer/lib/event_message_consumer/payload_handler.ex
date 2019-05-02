defmodule Consumer.EventMessageConsumer.PayloadHandler do
  alias Consumer.Messages.Messages

  def handle(payload) do
    {:ok, decoded_payload} = Poison.decode(payload)

    decoded_payload
    |> keys_to_atoms()
    |> handle_payload()
  end

  defp handle_payload(%{event: "CREATE_SIMPLE_MESSAGE", data: data}) do
    case Messages.create_message(data) do
      {:ok, _message} -> :ok
      _ -> :reject
    end
  end

  defp handle_payload(%{event: event}) do
    :reject
  end

  defp handle_payload(%{event: _event, data: _data}) do
    :reject
  end

  def keys_to_atoms(string_key_map) when is_map(string_key_map) do
    for {key, val} <- string_key_map, into: %{} do
      if is_binary(key) do
        {String.to_atom(key), keys_to_atoms(val)}
      else
        {key, keys_to_atoms(val)}
      end
    end
  end
  def keys_to_atoms(value), do: value
end
