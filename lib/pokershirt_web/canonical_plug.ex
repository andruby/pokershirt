defmodule Pokershirt.CanonicalPlug do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _options) do
    if conn_uri(conn, conn.host) != canonical_uri(conn) do
      conn
      |> put_status(:moved_permanently)
      |> Phoenix.Controller.redirect(external: canonical_uri(conn))
      |> halt()
    else
      conn
    end
  end

  defp conn_uri(conn, host) do
    # Using URI.to_string for the default port logic
    URI.to_string(%URI{
      scheme: to_string(conn.scheme),
      port: conn.port,
      host: host
    })
  end

  defp canonical_uri(conn) do
    conn_uri(conn, PokershirtWeb.Endpoint.config(:url)[:host])
  end
end
