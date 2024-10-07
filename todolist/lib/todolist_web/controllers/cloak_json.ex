defmodule TodolistWeb.CloakJSON do
  alias Todolist.Time.Cloak

  @doc """
  Renders a list of clocks.
  """
  def index(%{clocks: clocks}) do
    %{data: for(cloak <- clocks, do: data(cloak))}
  end

  @doc """
  Renders a single cloak.
  """
  def show(%{cloak: cloak}) do
    %{data: data(cloak)}
  end

  defp data(%Cloak{} = cloak) do
    %{
      id: cloak.id,
      time: cloak.time,
      status: cloak.status
    }
  end
end
