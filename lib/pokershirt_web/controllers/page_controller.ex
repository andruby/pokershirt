defmodule PokershirtWeb.PageController do
  use PokershirtWeb, :controller
  alias Pokershirt.Haiku

  def index(conn, _params) do
    render(conn, "index.html", new_room_id: Haiku.room_name)
  end
end
