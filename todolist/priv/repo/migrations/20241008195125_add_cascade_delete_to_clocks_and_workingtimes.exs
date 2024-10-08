defmodule Todolist.Repo.Migrations.AddCascadeDeleteToClocksAndWorkingtimes do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE clocks DROP CONSTRAINT IF EXISTS clocks_user_fkey"

    alter table(:clocks) do
      modify :user, references(:users, on_delete: :delete_all)
    end
  end

  def change do
    alter table(:clocks) do
      modify :user, references(:users, on_delete: :delete_all)
    end

    alter table(:working_times) do
      modify :user, references(:users, on_delete: :delete_all)
    end
  end
end
