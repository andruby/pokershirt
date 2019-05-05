defmodule PokershirtWeb.RoomLive do
  use Phoenix.LiveView
  alias PokershirtWeb.{RoomView, Presence}
  alias Phoenix.Socket.Broadcast

  def render(assigns) do
    RoomView.render("room_live.html", assigns)
  end

  def mount(session, socket0) do
    socket = socket0
    |> assign(:room_id, session.room_id)
    |> assign(:user_uid, session.user_uid)
    |> assign(:val, 0)
    |> assign(:username, nil)

    Phoenix.PubSub.subscribe(Pokershirt.PubSub, "room:#{socket.assigns[:room_id]}")
    Presence.track(self(), "room:#{socket.assigns[:room_id]}", socket.assigns[:user_uid], %{})
    {:ok, fetch(socket)}
  end

  defp fetch(socket) do
    list = Presence.list("room:#{socket.assigns[:room_id]}")
    assign(socket, :online_users, list)
  end

  def handle_event("username_change", %{"username" => username}, socket) do
    Presence.update(self(), "room:#{socket.assigns[:room_id]}", socket.assigns[:user_uid], %{username: username})
    {:noreply, assign(socket, :username, username)}
  end

  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    {:noreply, fetch(socket)}
  end
end
