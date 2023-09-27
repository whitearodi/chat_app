defmodule ChatAppWeb.UserAuth do
  use ChatAppWeb, :verified_routes

  import Phoenix.Controller
  import Plug.Conn

  def log_in_users(conn, user) do
    users_return_to = get_session(conn, :users_return_to)
    # user = Accounts.get_users_by_email(params["email"])

    conn
    |> assign(:current_user, user)
    |> IO.inspect(label: "LOGIN")
    |> renew_session()
    |> put_session(:current_user, user)
    |> redirect(to: users_return_to || signed_in_path(conn))
  end

  def log_out_users(conn) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: ~p"/users/log_in")
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  def redirect_if_users_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  def fetch_current_users(conn, _opts) do
    user = get_session(conn, :current_user)
    assign(conn, :current_user, user)
  end

  def require_authenticated_users(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page")
      # |> maybe_store_return_to()
      |> redirect(to: ~p"/users/log_in")
      |> halt()
    end
  end

  # defp maybe_store_return_to(conn), do: conn

  defp signed_in_path(_conn), do: ~p"/"
end
