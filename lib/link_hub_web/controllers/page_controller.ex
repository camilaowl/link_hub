defmodule LinkHubWeb.PageController do
  use LinkHubWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
