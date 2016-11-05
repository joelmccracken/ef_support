defmodule EFSupport.APIController do
  use EFSupport.Web, :controller

  alias EFSupport.Task

  plug Addict.Plugs.Authenticated
  def app_init(conn, _params) do
    user_id = current_user(conn).id
    tasks = Task |> where(user_id: ^user_id) |> Repo.all

    render conn, "app_init.json-api", tasks: tasks
  end

  def create_task(conn, %{"name" => task_name}) do
    params = %{ name: task_name,
                complete: 0
              }

    changeset = Task.changeset(%Task{}, params)
      |> Ecto.Changeset.change(%{ user_id: current_user(conn).id})

    case Repo.insert(changeset) do
      {:ok, task} ->
        render conn, "create_task.json", task: task
      {:error, changeset} ->
        render(conn, "error.json", changeset: changeset)
    end
  end
end
