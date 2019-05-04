defmodule PokershirtWeb.RoomLive.Show do
  use Phoenix.LiveView
  alias PokershirtWeb.RoomView

  def render(assigns) do
    RoomView.render("show.html", assigns)
  end

  def mount(session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :timer_tick)

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

  def handle_info(:timer_tick, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end
end
