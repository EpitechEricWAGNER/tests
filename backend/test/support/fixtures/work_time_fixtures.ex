defmodule Todolist.WorkTimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todolist.WorkTime` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~N[2024-10-06 14:57:00],
        start: ~N[2024-10-06 14:57:00]
      })
      |> Todolist.WorkTime.create_working_time()

    working_time
  end
end
