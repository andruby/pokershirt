defmodule PokershirtWeb.RoomLive do
  use Phoenix.LiveView
  alias PokershirtWeb.{RoomView, Presence}
  alias Phoenix.Socket.Broadcast
  alias Pokershirt.Repo

  def render(assigns) do
    RoomView.render("room_live.html", assigns)
  end

  def mount(session, socket0) do
    socket = socket0
    |> assign(:room_id, session.room_id)
    |> assign(:user_uid, session.user_uid)

    Phoenix.PubSub.subscribe(Pokershirt.PubSub, "room:#{socket.assigns[:room_id]}:presence")
    Phoenix.PubSub.subscribe(Pokershirt.PubSub, "room:#{socket.assigns[:room_id]}:rounds")
    Presence.track(self(), "room:#{socket.assigns[:room_id]}:presence", socket.assigns[:user_uid], %{})
    {:ok, fetch(socket)}
  end

  defp fetch(socket) do
    list = Presence.list("room:#{socket.assigns[:room_id]}:presence")
    {_, %{metas: [our_metas]}} = Enum.find(list, fn ({uuid, _}) -> uuid == socket.assigns[:user_uid] end)
    all_cast = Enum.all?(list, fn ({_, %{metas: [metas]}}) -> metas[:vote] end)

    socket
    |> assign(:online_users, list)
    |> assign(:username, our_metas[:username])
    |> assign(:vote, our_metas[:vote])
    |> assign(:all_cast, all_cast)
  end

  def handle_event("username_change", %{"username" => username}, socket) do
    Presence.update(self(), "room:#{socket.assigns[:room_id]}:presence", socket.assigns[:user_uid], &(Map.put(&1, :username, username)))
    {:noreply, socket}
  end

  def handle_event("vote", value, socket) do
    unless socket.assigns[:all_cast] do
      Pokershirt.Metric.increment(Repo, :total_votes)
      Presence.update(self(), "room:#{socket.assigns[:room_id]}:presence", socket.assigns[:user_uid], &(Map.put(&1, :vote, value)))
    end
    {:noreply, socket}
  end

  def handle_event("new_round", _, socket) do
    Pokershirt.Metric.increment(Repo, :total_rounds)
    # Notify all LiveViews to reset their votes
    Phoenix.PubSub.broadcast(Pokershirt.PubSub, "room:#{socket.assigns[:room_id]}:rounds", "new_round")
    {:noreply, socket}
  end

  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_info("new_round", socket) do
    # Reset our user's vote
    Presence.update(self(), "room:#{socket.assigns[:room_id]}:presence", socket.assigns[:user_uid], &(Map.put(&1, :vote, nil)))
    {:noreply, socket}
  end
end
