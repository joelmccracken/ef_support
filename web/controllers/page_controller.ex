defmodule EfSupport.PageController do
  use EfSupport.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def app(conn, _params) do
    render conn, "elm_app.html"
  end
end
