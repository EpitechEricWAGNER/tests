defmodule Todolist.WorkTimeTest do
  use Todolist.DataCase

  alias Todolist.WorkTime

  describe "workingtime" do
    alias Todolist.WorkTime.WorkingTime

    import Todolist.WorkTimeFixtures

    @invalid_attrs %{end: nil, start: nil}

    test "list_workingtime/0 returns all workingtime" do
      working_time = working_time_fixture()
      assert WorkTime.list_workingtime() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert WorkTime.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{end: ~N[2024-10-06 14:57:00], start: ~N[2024-10-06 14:57:00]}

      assert {:ok, %WorkingTime{} = working_time} = WorkTime.create_working_time(valid_attrs)
      assert working_time.end == ~N[2024-10-06 14:57:00]
      assert working_time.start == ~N[2024-10-06 14:57:00]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkTime.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{end: ~N[2024-10-07 14:57:00], start: ~N[2024-10-07 14:57:00]}

      assert {:ok, %WorkingTime{} = working_time} = WorkTime.update_working_time(working_time, update_attrs)
      assert working_time.end == ~N[2024-10-07 14:57:00]
      assert working_time.start == ~N[2024-10-07 14:57:00]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkTime.update_working_time(working_time, @invalid_attrs)
      assert working_time == WorkTime.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = WorkTime.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> WorkTime.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = WorkTime.change_working_time(working_time)
    end
  end
end
