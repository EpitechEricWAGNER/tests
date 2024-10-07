defmodule TodolistWeb.WorkingTimeController do
  use TodolistWeb, :controller

  alias Todolist.WorkTime
  alias Todolist.WorkTime.WorkingTime

  action_fallback TodolistWeb.FallbackController

  def index(conn, _params) do
    workingtime = WorkTime.list_workingtime()
    render(conn, :index, workingtime: workingtime)
  end

  def create(conn, %{"working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- WorkTime.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtime/#{working_time}")
      |> render(:show, working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = WorkTime.get_working_time!(id)
    render(conn, :show, working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = WorkTime.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- WorkTime.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkTime.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- WorkTime.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
