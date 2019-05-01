# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :pokershirt, PokershirtWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6iZNGffWWbVPn4UG1Pjf8l1Nqw1DirWJ3fAk4R74fnTfjeuoAcvIxED21UrPoadn",
  render_errors: [view: PokershirtWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Pokershirt.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "w8qgqb5D3kgfR8wV1mSyeEJcvP/FOKfW"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
