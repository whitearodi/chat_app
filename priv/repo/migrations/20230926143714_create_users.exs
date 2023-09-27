defmodule ChatApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :password, :string, null: true
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime

      timestamps()
    end
  end
end
