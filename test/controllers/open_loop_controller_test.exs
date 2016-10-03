defmodule EfSupport.OpenLoopControllerTest do
  use EfSupport.ConnCase

  alias EfSupport.OpenLoop
  @valid_attrs %{complete: 42, name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, open_loop_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing open loops"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, open_loop_path(conn, :new)
    assert html_response(conn, 200) =~ "New open loop"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, open_loop_path(conn, :create), open_loop: @valid_attrs
    assert redirected_to(conn) == open_loop_path(conn, :index)
    assert Repo.get_by(OpenLoop, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, open_loop_path(conn, :create), open_loop: @invalid_attrs
    assert html_response(conn, 200) =~ "New open loop"
  end

  test "shows chosen resource", %{conn: conn} do
    open_loop = Repo.insert! %OpenLoop{}
    conn = get conn, open_loop_path(conn, :show, open_loop)
    assert html_response(conn, 200) =~ "Show open loop"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, open_loop_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    open_loop = Repo.insert! %OpenLoop{}
    conn = get conn, open_loop_path(conn, :edit, open_loop)
    assert html_response(conn, 200) =~ "Edit open loop"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    open_loop = Repo.insert! %OpenLoop{}
    conn = put conn, open_loop_path(conn, :update, open_loop), open_loop: @valid_attrs
    assert redirected_to(conn) == open_loop_path(conn, :show, open_loop)
    assert Repo.get_by(OpenLoop, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    open_loop = Repo.insert! %OpenLoop{}
    conn = put conn, open_loop_path(conn, :update, open_loop), open_loop: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit open loop"
  end

  test "deletes chosen resource", %{conn: conn} do
    open_loop = Repo.insert! %OpenLoop{}
    conn = delete conn, open_loop_path(conn, :delete, open_loop)
    assert redirected_to(conn) == open_loop_path(conn, :index)
    refute Repo.get(OpenLoop, open_loop.id)
  end
end
