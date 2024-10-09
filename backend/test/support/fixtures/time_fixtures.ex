defmodule Todolist.TimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todolist.Time` context.
  """

  @doc """
  Generate a cloak.
  """
  def cloak_fixture(attrs \\ %{}) do
    {:ok, cloak} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2024-10-06 14:56:00]
      })
      |> Todolist.Time.create_cloak()

    cloak
  end
end
