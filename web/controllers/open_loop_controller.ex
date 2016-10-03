defmodule EfSupport.OpenLoopController do
  use EfSupport.Web, :controller

  alias EfSupport.OpenLoop

  def index(conn, _params) do
    open_loops = Repo.all(OpenLoop)
    render(conn, "index.html", open_loops: open_loops)
  end

  def new(conn, _params) do
    changeset = OpenLoop.changeset(%OpenLoop{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"open_loop" => open_loop_params}) do
    changeset = OpenLoop.changeset(%OpenLoop{}, open_loop_params)

    case Repo.insert(changeset) do
      {:ok, _open_loop} ->
        conn
        |> put_flash(:info, "Open loop created successfully.")
        |> redirect(to: open_loop_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    open_loop = Repo.get!(OpenLoop, id)
    render(conn, "show.html", open_loop: open_loop)
  end

  def edit(conn, %{"id" => id}) do
    open_loop = Repo.get!(OpenLoop, id)
    changeset = OpenLoop.changeset(open_loop)
    render(conn, "edit.html", open_loop: open_loop, changeset: changeset)
  end

  def update(conn, %{"id" => id, "open_loop" => open_loop_params}) do
    open_loop = Repo.get!(OpenLoop, id)
    changeset = OpenLoop.changeset(open_loop, open_loop_params)

    case Repo.update(changeset) do
      {:ok, open_loop} ->
        conn
        |> put_flash(:info, "Open loop updated successfully.")
        |> redirect(to: open_loop_path(conn, :show, open_loop))
      {:error, changeset} ->
        render(conn, "edit.html", open_loop: open_loop, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    open_loop = Repo.get!(OpenLoop, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(open_loop)

    conn
    |> put_flash(:info, "Open loop deleted successfully.")
    |> redirect(to: open_loop_path(conn, :index))
  end
end
