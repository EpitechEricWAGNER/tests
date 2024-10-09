defmodule TodolistWeb.CloakController do
  use TodolistWeb, :controller
  alias Todolist.Time
  alias Todolist.Time.Cloak

  action_fallback TodolistWeb.FallbackController

  def index(conn, _params) do
    clocks = Time.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"userID" => user_id}) do
    time = DateTime.utc_now()
    status = true

    cloak_params = %{
      "user" => user_id,
      "time" => time,
      "status" => status
    }

    case Time.create_cloak(cloak_params) do
      {:ok, cloak} ->
        conn
        |> put_status(:created)
        |> render(:show, cloak: cloak)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset})
    end
  end

  def show(conn, %{"userID" => user_id}) do
    cloak = Time.get_cloak!(user_id)
    render(conn, :index, clocks: cloak)
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
