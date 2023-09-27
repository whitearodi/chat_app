defmodule ChatApp.Repo.Migrations.CreateUserRooms do
  use Ecto.Migration

  def change do
    create table(:user_rooms) do
      add :sender_id, references(:users, on_delete: :nothing)
      add :room_id, references(:rooms, on_delete: :nothing)
    end
  end
end
