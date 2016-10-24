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

    resources "/open_loops", OpenLoopController

    get "/api/app_init", APIController, :app_init
    post "/api/create_task", APIController, :create_task

    resources "/api/tasks", API.TaskController, except: [:new, :edit]
    # post "/api/update_tasks", API.TaskController, :update_tasks
  end

  scope "/" do
    addict :routes
  end

  # Other scopes may use custom stacks.
  # scope "/api", EfSupport do
  #   pipe_through :api
  # end
end
