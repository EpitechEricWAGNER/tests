defmodule Todolist.Time do
  @moduledoc """
  The Time context.
  """

  import Ecto.Query, warn: false
  alias Todolist.Repo

  alias Todolist.Time.Cloak

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Cloak{}, ...]

  """
  def list_clocks do
    Repo.all(Cloak)
  end

  @doc """
  Gets a single cloak.

  Raises `Ecto.NoResultsError` if the Cloak does not exist.

  ## Examples

      iex> get_cloak!(123)
      %Cloak{}

      iex> get_cloak!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cloak!(user_id), do: Repo.all(from c in Cloak, where: c.user == ^user_id)

  @doc """
  Creates a cloak.

  ## Examples

      iex> create_cloak(%{field: value})
      {:ok, %Cloak{}}

      iex> create_cloak(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cloak(attrs \\ %{}) do
    %Cloak{}
    |> Cloak.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cloak.

  ## Examples

      iex> update_cloak(cloak, %{field: new_value})
      {:ok, %Cloak{}}

      iex> update_cloak(cloak, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cloak(%Cloak{} = cloak, attrs) do
    cloak
    |> Cloak.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cloak.

  ## Examples

      iex> delete_cloak(cloak)
      {:ok, %Cloak{}}

      iex> delete_cloak(cloak)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cloak(%Cloak{} = cloak) do
    Repo.delete(cloak)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cloak changes.

  ## Examples

      iex> change_cloak(cloak)
      %Ecto.Changeset{data: %Cloak{}}

  """
  def change_cloak(%Cloak{} = cloak, attrs \\ %{}) do
    Cloak.changeset(cloak, attrs)
  end
end
