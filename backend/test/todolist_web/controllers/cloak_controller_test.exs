defmodule TodolistWeb.CloakControllerTest do
  use TodolistWeb.ConnCase

  import Todolist.TimeFixtures

  alias Todolist.Time.Cloak

  @create_attrs %{
    status: true,
    time: ~N[2024-10-06 14:56:00]
  }
  @update_attrs %{
    status: false,
    time: ~N[2024-10-07 14:56:00]
  }
  @invalid_attrs %{status: nil, time: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all clocks", %{conn: conn} do
      conn = get(conn, ~p"/api/clocks")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create cloak" do
    test "renders cloak when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/clocks", cloak: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/clocks/#{id}")

      assert %{
               "id" => ^id,
               "status" => true,
               "time" => "2024-10-06T14:56:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/clocks", cloak: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update cloak" do
    setup [:create_cloak]

    test "renders cloak when data is valid", %{conn: conn, cloak: %Cloak{id: id} = cloak} do
      conn = put(conn, ~p"/api/clocks/#{cloak}", cloak: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/clocks/#{id}")

      assert %{
               "id" => ^id,
               "status" => false,
               "time" => "2024-10-07T14:56:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, cloak: cloak} do
      conn = put(conn, ~p"/api/clocks/#{cloak}", cloak: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete cloak" do
    setup [:create_cloak]

    test "deletes chosen cloak", %{conn: conn, cloak: cloak} do
      conn = delete(conn, ~p"/api/clocks/#{cloak}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/clocks/#{cloak}")
      end
    end
  end

  defp create_cloak(_) do
    cloak = cloak_fixture()
    %{cloak: cloak}
  end
end
