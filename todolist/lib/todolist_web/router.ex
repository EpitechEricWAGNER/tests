defmodule TodolistWeb.Router do
  use TodolistWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TodolistWeb do
    pipe_through :api

    resources "/users", UserController, except: [:index, :edit, :new]

    resources "/workingtime", WorkingTimeController, except: [:edit, :new]

    resources "/clocks", CloakController, except: [:index, :create]

    get "/users", UserController, :search

    get "/workingtime/:userID/:id", WorkingTimeController, :show
  end
end
