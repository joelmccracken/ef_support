defmodule EfSupport.APIController do
  use EfSupport.Web, :controller

  alias EfSupport.{Task,User}

  plug Addict.Plugs.Authenticated

  require IEx

  def bootstrap(conn, _params) do
    user_id = current_user(conn).id
    tasks = Task |> where(user_id: ^user_id) |> Repo.all

    render conn, "bootstrap.json", tasks: tasks
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

  def update_task(conn, %{"id" => id, "task" => task_params}) do
    task = Repo.get!(Task, id)
    changeset = Task.changeset(task, task_params)

    case Repo.update(changeset) do
      {:ok, task} ->
        render(conn, "update_task.json", task: task)
      {:error, changeset} ->
        render(conn, "error.json", changeset: changeset)
    end
  end
end
