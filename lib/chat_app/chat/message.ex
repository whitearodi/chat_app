defmodule ChatApp.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias ChatApp.Chat.Room
  alias ChatApp.Chat.User

  schema "messages" do
    field :content, :string
    belongs_to :room, Room
    belongs_to :sender, User
    timestamps()
  end

  def changeset(message, params) do
    message
    |> cast(params, [:content, :room_id, :sender_id])
    |> validate_required([:content, :room_id])
  end
end
