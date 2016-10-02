defmodule EfSupport.TaskView do
  use EfSupport.Web, :view

  require IEx

  def render("task_list.html", %{tasks: tasks, conn: conn}) do
    calced_completion = Enum.map(tasks, &calculate_completion/1)

    is_complete = fn(calculated)-> calculated.complete end

    complete = calced_completion |> Enum.filter is_complete
    incomplete = calced_completion |> Enum.reject is_complete

    render("task_list.html", %{complete: complete, incomplete: incomplete, conn: conn})
  end

  def calculate_completion(task) do
    changes = Ecto.Changeset.change(task, %{complete: 1})
    %{
      name: task.name,
      complete: task.complete > 0,
      id: task.id,
      task: task,
      mark_complete: changes
    }
  end

  def boolean_toggle_form(decorated_task) do
  end
end
