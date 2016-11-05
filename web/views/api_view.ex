defmodule EFSupport.APIView do
  use EFSupport.Web, :view

  require IEx

  def render("app_init.json-api", %{tasks: tasks, conn: conn}) do
    tasks1 = Enum.map(tasks, &render_task/1)

    JaSerializer.format(EFSupport.TaskView, tasks, conn)
  end

  def render("create_task.json", %{task: task}) do
    %{data: %{task: render_task(task)}}
  end

  def render("update_task.json", %{task: task}) do
    %{data: %{task: render_task(task)}}
  end

  def render("error.json", %{changeset: _changeset}) do
    %{error: "there was an error"}
  end


  defp render_task(task) do
    %{
      name: task.name,
      id: task.id,
      complete: task.complete,
      user_id: task.user_id
    }
  end
end
