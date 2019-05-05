defmodule PokershirtWeb.RoomController do
  use PokershirtWeb, :controller
  alias Phoenix.LiveView
  alias PokershirtWeb.RoomLive.Show

  # TODO: Move this to "ApplicationController"?
  plug :ensure_session_user_uid

  def show(conn, %{"id" => room_id}) do
    LiveView.Controller.live_render(conn, Show, session: %{room_id: room_id, user_uid: get_session(conn, :user_uid)})
  end

  defp ensure_session_user_uid(conn, _) do
    case get_session(conn, :user_uid) do
      nil -> put_session(conn, :user_uid, Ecto.UUID.generate())
      _uuid -> conn
    end
  end
end
