# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :pokershirt,
  ecto_repos: [Pokershirt.Repo]

# Configures the endpoint
config :pokershirt, PokershirtWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: PokershirtWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Pokershirt.PubSub,
  live_view: [signing_salt: "Z8MzmMlB"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# See https://kevinlang.me/bulma-phoenix-1-6/
config :dart_sass,
  version: "1.49.11",
  default: [
    args: ~w(--load-path=../deps/bulma css:../priv/static/assets),
    cd: Path.expand("../assets", __DIR__)
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
