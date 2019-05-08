use Mix.Config

# Configure your database
config :pokershirt, Pokershirt.Repo,
  username: System.get_env["USER"],
  database: "pokershirt_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pokershirt, PokershirtWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
