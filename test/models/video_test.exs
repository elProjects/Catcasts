defmodule Catcasts.VideoTest do
  use Catcasts.ModelCase

  alias Catcasts.Video

  @valid_attrs %{duration: "some duration", thumbnail: "some thumbnail", title: "some title", video_id: "some video_id", view_count: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Video.changeset(%Video{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Video.changeset(%Video{}, @invalid_attrs)
    refute changeset.valid?
  end
end
