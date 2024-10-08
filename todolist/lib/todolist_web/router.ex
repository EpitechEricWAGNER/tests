defmodule TodolistWeb.Router do
  use TodolistWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TodolistWeb do
    pipe_through :api

    resources "/users", UserController, except: [:index, :edit, :new]
    get "/users", UserController, :search

    resources "/workingtime", WorkingTimeController, except: [:show, :new]
    post "/workingtime/:userID", WorkingTimeController, :create
    get "/workingtime/:userID/:id", WorkingTimeController, :show
    get "/workingtime/:userID", WorkingTimeController, :show_with_params

    post "/clocks/:userID", CloakController, :create
    get "/clocks/:userID", CloakController, :show
  end
end
