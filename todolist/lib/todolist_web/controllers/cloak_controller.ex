defmodule TodolistWeb.CloakController do
  use TodolistWeb, :controller

  alias Todolist.Time
  alias Todolist.Time.Cloak

  action_fallback TodolistWeb.FallbackController

  def index(conn, _params) do
    clocks = Time.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"cloak" => cloak_params}) do
    with {:ok, %Cloak{} = cloak} <- Time.create_cloak(cloak_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{cloak}")
      |> render(:show, cloak: cloak)
    end
  end

  def show(conn, %{"id" => id}) do
    cloak = Time.get_cloak!(id)
    render(conn, :show, cloak: cloak)
  end

  def update(conn, %{"id" => id, "cloak" => cloak_params}) do
    cloak = Time.get_cloak!(id)

    with {:ok, %Cloak{} = cloak} <- Time.update_cloak(cloak, cloak_params) do
      render(conn, :show, cloak: cloak)
    end
  end

  def delete(conn, %{"id" => id}) do
    cloak = Time.get_cloak!(id)

    with {:ok, %Cloak{}} <- Time.delete_cloak(cloak) do
      send_resp(conn, :no_content, "")
    end
  end
end
