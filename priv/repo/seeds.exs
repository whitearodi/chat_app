# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ChatApp.Repo.insert!(%ChatApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Faker.start()

alias ChatApp.Chat.Room
alias ChatApp.Chat
alias ChatApp.Repo
alias ChatApp.Accounts

Repo.insert!(%Room{name: "Default", description: "This is the default page!"})

for n <- 1..10 do
  name = Faker.Person.first_name()
  email = "#{String.downcase(name)}@gmail.com"
  Accounts.registers_user(%{email: email, password: "password!!"})
end

for n <- 1..100 do
  Chat.create_message(%{
    content: Faker.Lorem.sentence(),
    room_id: Enum.random([1, 2]),
    sender_id: Enum.random([1, 2, 3, 4, 5, 6, 7])
  })
end
