defmodule Todolist.TimeTest do
  use Todolist.DataCase

  alias Todolist.Time

  describe "clocks" do
    alias Todolist.Time.Cloak

    import Todolist.TimeFixtures

    @invalid_attrs %{status: nil, time: nil}

    test "list_clocks/0 returns all clocks" do
      cloak = cloak_fixture()
      assert Time.list_clocks() == [cloak]
    end

    test "get_cloak!/1 returns the cloak with given id" do
      cloak = cloak_fixture()
      assert Time.get_cloak!(cloak.id) == cloak
    end

    test "create_cloak/1 with valid data creates a cloak" do
      valid_attrs = %{status: true, time: ~N[2024-10-06 14:56:00]}

      assert {:ok, %Cloak{} = cloak} = Time.create_cloak(valid_attrs)
      assert cloak.status == true
      assert cloak.time == ~N[2024-10-06 14:56:00]
    end

    test "create_cloak/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Time.create_cloak(@invalid_attrs)
    end

    test "update_cloak/2 with valid data updates the cloak" do
      cloak = cloak_fixture()
      update_attrs = %{status: false, time: ~N[2024-10-07 14:56:00]}

      assert {:ok, %Cloak{} = cloak} = Time.update_cloak(cloak, update_attrs)
      assert cloak.status == false
      assert cloak.time == ~N[2024-10-07 14:56:00]
    end

    test "update_cloak/2 with invalid data returns error changeset" do
      cloak = cloak_fixture()
      assert {:error, %Ecto.Changeset{}} = Time.update_cloak(cloak, @invalid_attrs)
      assert cloak == Time.get_cloak!(cloak.id)
    end

    test "delete_cloak/1 deletes the cloak" do
      cloak = cloak_fixture()
      assert {:ok, %Cloak{}} = Time.delete_cloak(cloak)
      assert_raise Ecto.NoResultsError, fn -> Time.get_cloak!(cloak.id) end
    end

    test "change_cloak/1 returns a cloak changeset" do
      cloak = cloak_fixture()
      assert %Ecto.Changeset{} = Time.change_cloak(cloak)
    end
  end
end
