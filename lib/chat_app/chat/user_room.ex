defmodule ChatApp.Chat.UserRoom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_rooms" do
    belongs_to :sender, User
    belongs_to :room, Room
    timestamps()
  end

  def changeset(user_room, params \\ %{}) do
    user_room
    |> cast(params, [:sender_id, :room_id])
    |> validate_required([:sender_id, :room_id])
  end
end
