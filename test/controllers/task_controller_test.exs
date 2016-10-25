defmodule EfSupport.TaskControllerTest do
  use EfSupport.ConnCase

  alias EfSupport.Task
  alias EfSupport.Repo

  @valid_attrs %{complete: 42, name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  defp relationships do 
    user = Repo.insert!(%EfSupport.User{})

    %{
      "user" => %{
        "data" => %{
          "type" => "user",
          "id" => user.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, task_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    task = Repo.insert! %Task{}
    conn = get conn, task_path(conn, :show, task)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{task.id}"
    assert data["type"] == "task"
    assert data["attributes"]["name"] == task.name
    assert data["attributes"]["complete"] == task.complete
    assert data["attributes"]["user_id"] == task.user_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, task_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, task_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "task",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Task, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, task_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "task",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    task = Repo.insert! %Task{}
    conn = put conn, task_path(conn, :update, task), %{
      "meta" => %{},
      "data" => %{
        "type" => "task",
        "id" => task.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Task, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    task = Repo.insert! %Task{}
    conn = put conn, task_path(conn, :update, task), %{
      "meta" => %{},
      "data" => %{
        "type" => "task",
        "id" => task.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    task = Repo.insert! %Task{}
    conn = delete conn, task_path(conn, :delete, task)
    assert response(conn, 204)
    refute Repo.get(Task, task.id)
  end

end
