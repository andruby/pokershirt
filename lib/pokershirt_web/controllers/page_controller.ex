defmodule PokershirtWeb.PageController do
  use PokershirtWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", new_room_id: rand_chars(5))
  end

  defp rand_chars(length) do
    for _ <- 0..length do
      Integer.to_string(:rand.uniform(26) + 10, 36)
      |> String.downcase
    end
    |> Enum.join
  end
end
