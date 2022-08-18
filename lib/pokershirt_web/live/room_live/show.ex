defmodule PokershirtWeb.RoomLive.Show do
  use PokershirtWeb, :live_view
  alias PokershirtWeb.{Presence}
  alias Phoenix.Socket.Broadcast
  alias Pokershirt.Repo
  alias Pokershirt.Metric

  @size_options [
    {"?",  "<strong>?</strong>"},
    {"XS", "<strong>XS</strong>mall"},
    {"S", "<strong>S</strong>mall"},
    {"M",  "<strong>M</strong>edium"},
    {"L",  "<strong>L</strong>arge"},
    {"XL", "<strong>XL</strong>arge"},
  ]

  def mount(params, _session, socket) do
    room_id = params["room_id"]

    socket2 = socket
    |> assign(:room_id, room_id)
    |> assign(:size_options, @size_options)
    |> assign(:user_uid, socket.assigns[:user_id] || Ecto.UUID.generate())

    Phoenix.PubSub.subscribe(Pokershirt.PubSub, "room:#{room_id}:presence")
    Phoenix.PubSub.subscribe(Pokershirt.PubSub, "room:#{room_id}:rounds")
    Presence.track(self(), "room:#{room_id}:presence", socket2.assigns[:user_uid], %{username: socket2.assigns[:username]})
    {:ok, fetch(socket2)}
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
      Task.start(fn -> Metric.increment(Repo, :total_votes) end)
      Presence.update(self(), "room:#{socket.assigns[:room_id]}:presence", socket.assigns[:user_uid], &(Map.put(&1, :vote, value)))
    end
    {:noreply, socket}
  end

  def handle_event("new_round", _, socket) do
    Task.start(fn -> Metric.increment(Repo, :total_rounds) end)
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
