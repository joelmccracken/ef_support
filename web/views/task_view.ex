defmodule EfSupport.TaskView do
  use EfSupport.Web, :view

  require IEx

  def render("task_list.html", %{tasks: tasks, conn: conn}) do

    calced_completion = Enum.map(tasks, fn(task) -> %{name: task.name, complete: task.complete > 0, id: task.id, task: task}  end)

    is_complete = fn(calculated)-> calculated.complete end

    complete = calced_completion |> Enum.filter is_complete
    incomplete = calced_completion |> Enum.reject is_complete

    render("task_list.html", %{complete: complete, incomplete: incomplete, conn: conn})
  end

  def incomplete(assigns) do
  end
end
