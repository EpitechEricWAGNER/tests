defmodule Todolist.WorkTime.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtime" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    belongs_to :user, Todolist.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(working_time, attrs, user) do
    working_time
    |> cast(attrs, [:start, :end])
    |> validate_required([:start, :end])
    |> put_assoc(:user, user)
  end
end
