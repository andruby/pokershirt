defmodule PokershirtWeb.RoomController do
  use PokershirtWeb, :controller
  alias Phoenix.LiveView
  alias PokershirtWeb.RoomLive.Show

  # TODO: Move this to "ApplicationController"?
  plug :ensure_session_uuid

  def show(conn, %{"id" => room_id}) do
    LiveView.Controller.live_render(conn, Show, session: %{room_id: room_id})
  end

  defp ensure_session_uuid(conn, _) do
    case get_session(conn, :uuid) do
      # TODO: Must be secure uuid
      nil -> put_session(conn, :uuid, "lool")
      uuid -> conn
    end
  end
end
