defmodule ChatApp.Chat do
  import Ecto.Query, warn: false

  alias ChatApp.Repo
  alias ChatApp.Chat.Room
  alias ChatApp.Chat.Message
  alias ChatAppWeb.Endpoint

  def list_rooms() do
    Repo.all(Room)
  end

  def get_room!(id) do
    Repo.get(Room, id)
  end

  def get_message!(id) do
    Repo.get(Message, id)
  end

  def last_ten_messages_for(room_id) do
    # dont forget to make a query module
    Message.Query.for_room(room_id)
    |> Repo.all()

    # |> Repo.preload(:sender)
  end

  def last_user_message_for_room(room_id, user_id) do
    Message.Query.last_user_message_for_room(room_id, user_id)
    |> Repo.one()
  end

  def create_room(params \\ %{}) do
    %Room{}
    |> Room.changeset(params)
    |> Repo.insert()
  end

  def update_room(%Room{} = room, params \\ %{}) do
    room
    |> Room.changeset(params)
    |> Repo.update()
  end

  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  def change_room(%Room{}, params) do
    Room.changeset(%Room{}, params)
  end

  def change_message(%Message{}, params) do
    Message.changeset(%Message{}, params)
  end

  def create_message(params) do
    %Message{}
    |> Message.changeset(params)
    |> Repo.insert()
    |> publish_message_created()
  end

  def update_message(params) do
    %Message{}
    |> Message.changeset(params)
    |> Repo.insert()
    |> publish_message_updated()
  end

  # Inspect the params in message
  def preload_message_sender(message) do
    message |> Repo.preload(:sender)
  end

  def publish_message_created({:ok, message} = result) do
    Endpoint.broadcast("room:#{message.room_id}", "new_message", %{message: message})
    result
  end

  def publish_message_created(result), do: result

  def publish_message_updated({:ok, message} = result) do
    Endpoint.broadcast("room:#{message.room_id}", "updated_message", %{message: message})
    result
  end

  def publish_message_updated(result), do: result

  def get_previous_n_message(id, n) do
    Message.Query.previous_n(id, n)
    |> Repo.all()
    |> Repo.preload(:sender)
  end
end
