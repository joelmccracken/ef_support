defmodule EfSupport.APIController do
  use EfSupport.Web, :controller

  alias EfSupport.{Task,User}

  plug Addict.Plugs.Authenticated

  def bootstrap(conn, _params) do
    user_id = current_user(conn).id
    tasks = Task |> where(user_id: ^user_id) |> Repo.all

    render conn, "bootstrap.json", tasks: tasks
  end
end
