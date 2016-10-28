defmodule EFSupport.APIControllerTest do
  use EFSupport.ConnCase
  alias EFSupport.User
  @valid_attrs %{}
  @invalid_attrs %{}

  require IEx

  setup %{conn: conn} do
    %User{
      id: 123456,
      email: "abc@gmail.com",
      encrypted_password: Addict.Interactors.GenerateEncryptedPassword.call("password")
    } |> Repo.insert
    conn = put_req_header(conn, "accept", "application/json")
    conn = post(conn, login_path(conn, :login),
      email: "abc@gmail.com",
      password: "password")

    {:ok, conn: conn,
     user: Repo.get(User, 123456)}
  end

  test "has a bootstrap method", %{conn: conn} do
    conn = get conn, api_path(conn, :app_init)
    assert json_response(conn, 200)["data"] == %{"tasks" => []}
  end
end
