defmodule PokershirtWeb.PageController do
  use PokershirtWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
