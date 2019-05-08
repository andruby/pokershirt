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
    |> assign(:total_rounds, Pokershirt.Metric.get(Repo, :total_rounds))
    |> assign(:total_votes, Pokershirt.Metric.get(Repo, :total_votes))

    Phoenix.PubSub.subscribe(Pokershirt.PubSub, "metric:total_rounds")
    Phoenix.PubSub.subscribe(Pokershirt.PubSub, "metric:total_votes")
    {:ok, socket}
  end

  def handle_info({"metric_updated", key, value}, socket) do
    {:noreply, assign(socket, key, value)}
  end
end
