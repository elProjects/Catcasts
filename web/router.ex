defmodule Catcasts.Router do
  use Catcasts.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Catcasts do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end


  scope "/auth", Catcasts do
    pipe_through :browser
    
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :new
  end
  
  # Other scopes may use custom stacks.
  # scope "/api", Catcasts do
  #   pipe_through :api
  # end

end
