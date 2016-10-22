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
end
