defmodule PokershirtWeb.RoomLive.Show do
  use Phoenix.LiveView
  alias PokershirtWeb.RoomView

  def render(assigns) do
    RoomView.render("show.html", assigns)
  end

  def mount(session, socket) do
    socket2 = socket
    |> assign(:room_id, session.room_id)
    |> assign(:val, 0)
    {:ok, socket2}
  end

  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end
end
