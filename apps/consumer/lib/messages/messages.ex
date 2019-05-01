defmodule Consumer.Messages.Messages do

  import Ecto.Query, warn: false
  alias Consumer.Repo
  alias Consumer.Messages.Message

  def create_message(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end
end
