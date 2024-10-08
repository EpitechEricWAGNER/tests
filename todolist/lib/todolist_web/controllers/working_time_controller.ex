defmodule TodolistWeb.WorkingTimeController do
  use TodolistWeb, :controller

  alias Todolist.WorkTime
  alias Todolist.WorkTime.WorkingTime

  action_fallback TodolistWeb.FallbackController

  def create(conn, params) do
    user_id = Map.get(params, "userID")
    start = Map.get(params, "start")
    ends = Map.get(params, "end")
    params = %{"user" => user_id}
    workingtime_params = Map.put(params, "start", start)
    workingtime_params = Map.put(workingtime_params, "end", ends)

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

  def show_with_params(conn, params) do
    user_id = Map.get(params, "userID")
    starts = Map.get(params, "start")
    ends = Map.get(params, "end")

    workingtime_params = %{"user" => user_id, "start" => starts, "end" => ends}

    case WorkTime.list_workingtime(workingtime_params) do
      working_times ->
        conn
        |> put_status(:ok)
        |> json(working_times)
    end
  end
end
