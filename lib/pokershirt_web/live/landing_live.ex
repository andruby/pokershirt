defmodule PokershirtWeb.LandingLive do
  use Phoenix.LiveView
  alias PokershirtWeb.PageView
  alias Pokershirt.Repo

  def render(assigns) do
    PageView.render("landing_live.html", assigns)
  end

  def mount(session, socket0) do
    socket = socket0
    |> assign(:new_room_id, session.new_room_id)
    |> assign(:total_rounds, 0)
    |> assign(:total_votes, 0)

    async_fetch_metrics()
    Phoenix.PubSub.subscribe(Pokershirt.PubSub, "metric:total_rounds")
    Phoenix.PubSub.subscribe(Pokershirt.PubSub, "metric:total_votes")
    {:ok, socket}
  end

  defp async_fetch_metrics() do
    pid = self()
    Task.start(fn ->
      send pid, {"metric_updated", :total_rounds, Pokershirt.Metric.get(Repo, :total_rounds)}
      send pid, {"metric_updated", :total_votes, Pokershirt.Metric.get(Repo, :total_votes)}
    end)
  end

  def handle_info({"metric_updated", key, value}, socket) do
    {:noreply, assign(socket, key, value)}
  end
end
