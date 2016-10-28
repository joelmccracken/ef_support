defmodule EfSupport.APIView do
  use EfSupport.Web, :view

  require IEx

  def render("app_init.json", %{tasks: tasks}) do
    tasks = Enum.map(tasks, &render_task/1)

    %{data: %{tasks: tasks}}
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
      complete: task.complete
    }
  end
end
