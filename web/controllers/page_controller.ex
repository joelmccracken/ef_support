defmodule EfSupport.PageController do
  use EfSupport.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
