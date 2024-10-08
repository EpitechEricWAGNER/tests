defmodule TodolistWeb.WorkingTimeController do
  use TodolistWeb, :controller

  alias Todolist.WorkTime
  alias Todolist.WorkTime.WorkingTime
  alias Todolist.Accounts
  alias Todolist.Accounts.User

  action_fallback TodolistWeb.FallbackController

  def index(conn, _params) do
    workingtime = WorkTime.list_workingtime()
    render(conn, :index, workingtime: workingtime)
  end

  def create(conn, params) do
    # Console outpu params
    IO.puts("Params: #{inspect(params)}")

    user_id = Map.get(params, "userID")
    start = Map.get(params, "start")
    ends = Map.get(params, "end")
    IO.puts("Params: #{inspect(user_id)}")
    IO.puts("Params: #{inspect(start)}")
    IO.puts("Params: #{inspect(ends)}")
    params = %{"user" => user_id}
    workingtime_params = Map.put(params, "start", start)
    workingtime_params = Map.put(workingtime_params, "end", ends)
    IO.puts("Params: #{inspect(workingtime_params)}")
    case WorkTime.create_working_time(workingtime_params) do
      {:ok, working_time} ->
        conn
        |> put_status(:created)
        |> render(:show, working_time: working_time)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: changeset})
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = WorkTime.get_working_time!(id)
    render(conn, :show, working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = WorkTime.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <-
           WorkTime.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkTime.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- WorkTime.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end

  def show(conn, %{"userID" => user_id, "id" => id}) do
    case WorkTime.get_workingtime_by_user(user_id, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "WorkingTime not found"})

      working_time ->
        render(conn, "show.json", working_time: working_time)
    end
  end
end
