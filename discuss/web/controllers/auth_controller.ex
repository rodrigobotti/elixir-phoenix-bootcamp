defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug(Ueberauth)

  alias Discuss.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider}) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: provider}

    %User{}
    |> User.changeset(user_params)
    |> sign_in(conn)
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)

      user ->
        {:ok, user}
    end
  end

  def sign_out(conn, _params) do
    conn
    |> configure_session(drop: true) # remove everything related to the current session
    |> redirect(to: topic_path(conn, :index))
  end

  defp sign_in(changeset, conn) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end
end
