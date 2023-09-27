defmodule ChatApp.Chat.Room do
  use Ecto.Schema

  import Ecto.Changeset
  alias ChatApp.Chat.Message

  schema "rooms" do
    field :description, :string
    field :name, :string
    has_many :messages, Message
    many_to_many :users, ChatApp.Chat.User, join_through: ChatApp.Chat.UserRoom
    timestamps()
  end

  def changeset(room, params) do
    room
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
  end
end
