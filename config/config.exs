# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :humid,
  ecto_repos: [Humid.Repo],
  github_personal_api_key: System.get_env("GITHUB_PERSONAL_API_KEY")

config :darkskyx,
  api_key: System.get_env("DARKSKY_API_KEY"),
  defaults: [
    units: "us",
    lang: "en",
    longitude: -104.828918,
    latitude: 39.388763
  ]

# Configures the endpoint
config :humid, HumidWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+t+Gw/S/jHJQKlpOmISBa4ICZG1X3JW7vRi3eqjcPMOsaLsZefRat3TWlQtrB64C",
  render_errors: [view: HumidWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Humid.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
