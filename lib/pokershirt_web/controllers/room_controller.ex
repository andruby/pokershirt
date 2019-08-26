defmodule PokershirtWeb.RoomController do
  use PokershirtWeb, :controller

  # TODO: Move this to "ApplicationController"?
  plug :ensure_session_user_uid

  def show(conn, %{"id" => room_id}) do
    cookie_username = URI.decode(conn.req_cookies["pokershirt_username"])
    live_render(conn, PokershirtWeb.RoomLive, session: %{room_id: room_id, user_uid: get_session(conn, :user_uid), username: cookie_username})
  end

  defp ensure_session_user_uid(conn, _) do
    case get_session(conn, :user_uid) do
      nil -> put_session(conn, :user_uid, Ecto.UUID.generate())
      _uuid -> conn
    end
  end
end
