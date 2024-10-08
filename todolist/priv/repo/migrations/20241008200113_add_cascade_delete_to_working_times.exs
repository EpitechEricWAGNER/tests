defmodule Todolist.Repo.Migrations.AddCascadeDeleteToWorkingTimes do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE workingtime DROP CONSTRAINT IF EXISTS workingtime_user_fkey"

    alter table(:workingtime) do
      modify :user, references(:users, on_delete: :delete_all)
    end
  end
end
