defmodule EFSupport.PageControllerTest do
  use EFSupport.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "some marketing stuff"
  end
end
