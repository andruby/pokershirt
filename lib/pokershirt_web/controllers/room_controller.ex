defmodule PokershirtWeb.RoomController do
  use PokershirtWeb, :controller
  alias Phoenix.LiveView
  alias PokershirtWeb.RoomLive.Show

  def show(conn, %{"id" => room_id}) do
    LiveView.Controller.live_render(conn, Show, session: %{room_id: room_id})
  end
end
