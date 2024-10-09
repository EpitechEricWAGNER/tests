defmodule Todolist.WorkTime.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :start, :end, :user, :inserted_at, :updated_at]}
  schema "workingtime" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    field :user, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :user])
    |> validate_required([:start, :end, :user])
  end
end