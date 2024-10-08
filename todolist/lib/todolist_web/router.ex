defmodule TodolistWeb.Router do
  use TodolistWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TodolistWeb do
    pipe_through :api

    resources "/users", UserController, except: [:edit, :new]
    get "/users/:userID", UserController, :show

    resources "/workingtime", WorkingTimeController, except: [:edit, :new]
    post "/workingtime/:userID", WorkingTimeController, :create

    get "/workingtime/:userID/:id", WorkingTimeController, :show
    get "/workingtime/:userID", WorkingTimeController, :show_with_params

    resources "/clocks", CloakController, except: [:index, :create]

    get "/users", UserController, :search

    get "/workingtime/:userID/:id", WorkingTimeController, :show
  end
end
