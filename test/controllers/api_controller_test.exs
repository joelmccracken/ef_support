defmodule EfSupport.APIControllerTest do
  use EfSupport.ConnCase

  alias EfSupport.API
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    api = Repo.insert! %API{}
    conn = get conn, api_path(conn, :show, api)
    assert json_response(conn, 200)["data"] == %{"id" => api.id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, api_path(conn, :create), api: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(API, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, api_path(conn, :create), api: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    api = Repo.insert! %API{}
    conn = put conn, api_path(conn, :update, api), api: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(API, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    api = Repo.insert! %API{}
    conn = put conn, api_path(conn, :update, api), api: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    api = Repo.insert! %API{}
    conn = delete conn, api_path(conn, :delete, api)
    assert response(conn, 204)
    refute Repo.get(API, api.id)
  end
end
