defmodule EFSupport.API.TaskController do
  use EFSupport.Web, :controller

  alias EFSupport.Task
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    tasks = Repo.all(Task)
    render(conn, "index.json-api", data: tasks)
  end

  def create(conn, %{"data" => data = %{"type" => "task", "attributes" => _task_params}}) do
    changeset = Task.changeset(%Task{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, task} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", task_path(conn, :show, task))
        |> render("show.json-api", data: task)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Repo.get!(Task, id)
    render(conn, "show.json-api", data: task)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "task", "attributes" => _task_params}}) do
    task = Repo.get!(Task, id)
    changeset = Task.changeset(task, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, task} ->
        render(conn, "show.json-api", data: task)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Repo.get!(Task, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(task)

    send_resp(conn, :no_content, "")
  end
end
