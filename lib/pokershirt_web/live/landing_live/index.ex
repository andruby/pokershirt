defmodule PokershirtWeb.LandingLive.Index do
  use PokershirtWeb, :live_view
  alias Pokershirt.Repo
  alias Pokershirt.Metric

  def mount(_params, _session, socket) do
    socket2 = socket
    |> assign(:new_room_id, Pokershirt.Haiku.room_name)
    |> assign(:total_rounds, Metric.get(Repo, :total_rounds))
    |> assign(:total_votes, Metric.get(Repo, :total_votes))

    Phoenix.PubSub.subscribe(Pokershirt.PubSub, "metric:total_rounds")
    Phoenix.PubSub.subscribe(Pokershirt.PubSub, "metric:total_votes")
    {:ok, socket2}
  end

  def handle_info({"metric_updated", key, value}, socket) do
    {:noreply, assign(socket, key, value)}
  end
end
