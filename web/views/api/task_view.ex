defmodule EfSupport.API.TaskView do
  use EfSupport.Web, :view

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, EfSupport.API.TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, EfSupport.API.TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{id: task.id}
  end

  # def render("task_list.html", %{tasks: tasks, conn: conn}) do
  #   calced_completion = Enum.map(tasks, &calculate_completion/1)

  #   is_complete = fn(calculated)-> calculated.complete end

  #   complete = calced_completion |> Enum.filter(is_complete)
  #   incomplete = calced_completion |> Enum.reject(is_complete)

  #   render("task_list.html", %{complete: complete, incomplete: incomplete, conn: conn})
  # end

  # def calculate_completion(task) do
  #   changes = Ecto.Changeset.change(task, %{complete: 1})
  #   %{
  #     name: task.name,
  #     complete: task.complete > 0,
  #     id: task.id,
  #     task: task,
  #     mark_complete: changes
  #   }
  # end
end
