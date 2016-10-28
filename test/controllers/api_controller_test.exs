defmodule EFSupport.APIControllerTest do
  use EFSupport.ConnCase
  alias EFSupport.{User,Task}
  @valid_attrs %{}
  @invalid_attrs %{}

  require IEx

  describe "the bootstrap method" do
    setup %{conn: conn} do
      %User{
        id: 1,
        email: "abc@gmail.com",
        encrypted_password: Addict.Interactors.GenerateEncryptedPassword.call("password")
      } |> Repo.insert

      %User{
        id: 2,
        email: "other@gmail.com",
        encrypted_password: Addict.Interactors.GenerateEncryptedPassword.call("password")
      } |> Repo.insert

      conn = put_req_header(conn, "accept", "application/json")
      conn = post(conn, login_path(conn, :login),
        email: "abc@gmail.com",
        password: "password")

      {:ok, conn: conn,
       user: Repo.get(User, 1),
       other_user: Repo.get(User, 2)
      }
    end

    def convert_map_atom_keys_to_strings(map) do
      map
        |> Enum.map(
          fn({key, val})->
            {to_string(key), val}
          end)
        |> Map.new()
    end

    test "returns a list of users tasks", %{conn: conn, user: user} do
      task_attrs = %{
        id: 2,
        name: "a task",
        complete: 0,
        user_id: user.id
      }

      struct(Task, task_attrs) |> Repo.insert
      conn = get conn, api_path(conn, :app_init)

      expected_response_data = %{"tasks" => [convert_map_atom_keys_to_strings task_attrs]}

      assert json_response(conn, 200)["data"] == expected_response_data
    end
  end
end
