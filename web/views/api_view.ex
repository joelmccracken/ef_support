defmodule EfSupport.APIView do
  use EfSupport.Web, :view

  require IEx

  def render("bootstrap.json", %{tasks: tasks}) do
    tasks = Enum.map(tasks, &render_task/1)

    %{data: %{tasks: tasks}}
  end

  defp render_task(task) do
    %{
      name: task.name,
      id: task.id,
      complete: task.complete
    }
  end
end
