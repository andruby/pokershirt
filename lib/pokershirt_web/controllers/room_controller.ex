defmodule PokershirtWeb.RoomController do
  use PokershirtWeb, :controller

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", id: id)
  end
end
