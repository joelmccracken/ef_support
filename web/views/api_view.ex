defmodule EFSupport.APIView do
  use EFSupport.Web, :view

  require IEx

  defmodule ApiSerializer do
    use JaSerializer

    location "api/app_init"

    has_many :tasks,
      serializer: EFSupport.TaskView,
      include: true,
      links: [
        self: "api/tasks/:id"
      ]
  end

  def render("app_init.json-api", %{tasks: tasks, conn: conn}) do
    JaSerializer.format(ApiSerializer, %{tasks: tasks})
  end

  def render("error.json", %{changeset: _changeset}) do
    %{error: "there was an error"}
  end
end
