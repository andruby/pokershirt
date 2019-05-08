defmodule PokershirtWeb.PageController do
  use PokershirtWeb, :controller
  alias Pokershirt.Haiku
  alias Phoenix.LiveView

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, PokershirtWeb.LandingLive, session: %{new_room_id: Haiku.room_name})
  end
end
