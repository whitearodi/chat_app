defmodule ChatAppWeb.LoginLive.Index do
  alias ChatApp.Accounts
  use ChatAppWeb, :live_view

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "users")
    {:ok, assign(socket, form: form, trigger_submit: false), temporary_assigns: [form: form]}
  end

  def handle_event("save", %{"users" => %{"email" => email, "password" => password}}, socket) do
    if Accounts.get_user_by_email_and_password(email, password) do
      {:noreply, assign(socket, trigger_submit: true)}
    else
      {:noreply,
       socket
       |> put_flash(:error, "Invalid email or password!!")}
    end
  end
end
