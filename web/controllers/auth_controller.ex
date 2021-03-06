defmodule Catcasts.AuthController do
  use Catcasts.Web, :controller
  plug Ueberauth

  alias Catcasts.User

  def new(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{token: auth.credentials.token, first_name: auth.info.first_name, last_name: auth.info.last_name, email: auth.info.email, provider: "google"}
    changeset = User.changeset(%User{}, user_params)
    
    create(conn, changeset)
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Thank you for signing in!")
        |> put_session(:user_id, user.id)
        |> redirect(to: video_path(conn,:index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: "/")
    end
  end


  def create(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Thank you for signing in!")
        |> put_session(:user_id, user.id)
        |> redirect(to: "/")
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect("/")
    end
  end
  
  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end


  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
