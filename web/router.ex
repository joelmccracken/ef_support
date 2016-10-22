defmodule EfSupport.Router do
  use EfSupport.Web, :router
  use Addict.RoutesHelper

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

  scope "/", EfSupport do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/app", PageController, :app

    resources "/tasks", TaskController

    resources "/open_loops", OpenLoopController

    get "/api/bootstrap", APIController, :bootstrap
    post "/api/create_task", APIController, :create_task
    post "/api/update_task", APIController, :update_task
  end

  scope "/" do
    addict :routes
  end

  # Other scopes may use custom stacks.
  # scope "/api", EfSupport do
  #   pipe_through :api
  # end
end
