defmodule ChatApp.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias ChatApp.Chat.Room

  schema "messages" do
    field :content, :string
    belongs_to :room, Room
    belongs_to :sender, User
    timestamps()
  end

  def changeset(message, params) do
    message
    |> cast(params, [:content, :room_id])
    |> validate_required([:content, :room_id])
  end
end