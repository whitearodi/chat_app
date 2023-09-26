defmodule ChatApp.Chat.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt

  alias ChatApp.Accounts

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :naive_datetime
    # Assocaition with messages
    timestamps()
  end

  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_email(opts)
    |> validate_password(opts)
  end

  defp validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> validate_length(:email, max: 160)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> maybe_validate_unique_email(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 9)
    |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    |> maybe_hash_password(opts)
  end

  # Question
  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hashed_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> validate_length(:password, max: 60, count: :bytes)
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_email, true) do
      changeset
      |> unsafe_validate_unique(:email, AuthSystem.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  def email_changeset(user, attrs, opts \\ []) do
    user
    |> cast([:email], attrs)
    |> validate_email(opts)
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match ")
    |> validate_password(opts)
  end

  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  # verifies the password
  def valid_password?(%ChatApp.Chat.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(
      password,
      hashed_password
    )
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  # validate the password
  def validate_current_password(%{"email" => email} = params) do
    user = Accounts.get_user_by_email(email)

    if valid_password?(user, params["password"]) |> IO.inspect(label: "valid+++") do
      {:ok, true}
    else
      {:error, false}
      # add_error(:current_password, "is not valid")
    end
  end
end
