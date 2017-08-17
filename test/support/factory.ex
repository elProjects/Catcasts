defmodule Catcasts.Factory do
  use ExMachina.Ecto, repo: Catcasts.Repo

  def user_factory do
    %Catcasts.User{
      token: "ffnebyt73bich9",
      email: "batman@example.com",
      first_name: "Bruce",
      last_name: "Wayne",
      provider: "google"
    }
  end

  def video_factory do
    %Catcasts.Video{
      duration: "PT2M2S",
      thumbnail: "https://i.ytimg.com/vi/1rlSjdnAKY4/hqdefault.jpg",
      title: "Super Troopers (2/5) Movie CLIP - The Cat Game (2001) HD",
      video_id: "1rlSjdnAKY4",
      view_count: 658281
    }
  end
end
