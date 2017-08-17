defmodule Catcasts.VideoControllerTest do
  use Catcasts.ConnCase

  alias Catcasts.Video

  @valid_attrs %{video_id: "https://www.youtube.com/watch?v=wZZ7oFKsKzY"}
  @invalid_attrs %{video_id: ""}


  test "lists all entries on index", %{conn: conn} do
    conn = get conn, video_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing videos"
  end

  test "renders form for new resources", %{conn: conn} do
    user = insert(:user)
    
    conn = conn
    |> assign(:user, user)
    |> get(video_path(conn, :new))
    assert html_response(conn, 200) =~ "Add video"
  end

  
  test "creates resource and redirects when data is valid", %{conn: conn} do
    user = insert(:user)

    conn = conn
    |> bypass_through(Catcasts.Router, [:browser])
    |> get("/")
    |> put_session(:user_id, user.id)
    |> send_resp(:ok, "")
    |> recycle()
    |> assign(:set_user, user)
    |> post(video_path(conn, :create), video: @valid_attrs)

    video = Video |> Ecto.Query.last |> Repo.one
    assert redirected_to(conn) == video_path(conn, :show, video)
    assert get_flash(conn, :info) == "Video created successfully."
  end


  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    user = insert(:user)
  
    conn = conn
    |> assign(:user, user)
    |> post(video_path(conn, :create), video: @invalid_attrs)
   assert html_response(conn, 200) =~ "Add video"
  end

  
  test "shows chosen resource", %{conn: conn} do
    video = insert(:video)

    conn = get conn, video_path(conn, :show, video)
    assert html_response(conn, 200) =~ "Show video"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, video_path(conn, :show, -1)
    end
  end

  # test "renders form for editing chosen resource", %{conn: conn} do
  #   video = Repo.insert! %Video{}
  #   conn = get conn, video_path(conn, :edit, video)
  #   assert html_response(conn, 200) =~ "Edit video"
  # end

  # test "updates chosen resource and redirects when data is valid", %{conn: conn} do
  #   video = Repo.insert! %Video{}
  #   conn = put conn, video_path(conn, :update, video), video: @valid_attrs
  #   assert redirected_to(conn) == video_path(conn, :show, video)
  #   assert Repo.get_by(Video, @valid_attrs)
  # end

  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   video = Repo.insert! %Video{}
  #   conn = put conn, video_path(conn, :update, video), video: @invalid_attrs
  #   assert html_response(conn, 200) =~ "Edit video"
  # end


  test "deletes chosen resource", %{conn: conn} do
    user = insert(:user)
    video = insert(:video, user: user)

    conn = conn
    |> assign(:user, user)
    |> delete(video_path(conn, :delete, video))
    assert redirected_to(conn) == video_path(conn, :index)
    refute Repo.get(Video, video.id)
  end
end
