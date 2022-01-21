defmodule PokershirtWeb.LandingLive.Index do
  use PokershirtWeb, :live_view
  alias Pokershirt.Repo

  def mount(_params, _session, socket) do
    socket2 = socket
    |> assign(:new_room_id, "testroom")
    |> assign(:total_rounds, 0)
    |> assign(:total_votes, 0)

    async_fetch_metrics()
    Phoenix.PubSub.subscribe(Pokershirt.PubSub, "metric:total_rounds")
    Phoenix.PubSub.subscribe(Pokershirt.PubSub, "metric:total_votes")
    {:ok, socket2}
  end

  def handle_info({"metric_updated", key, value}, socket) do
    {:noreply, assign(socket, key, value)}
  end

  defp async_fetch_metrics() do
    pid = self()
    Task.start(fn ->
      send pid, {"metric_updated", :total_rounds, Pokershirt.Metric.get(Repo, :total_rounds)}
      send pid, {"metric_updated", :total_votes, Pokershirt.Metric.get(Repo, :total_votes)}
    end)
  end
end
