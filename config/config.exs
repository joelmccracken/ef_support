# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ef_support,
  ecto_repos: [EFSupport.Repo]

# Configures the endpoint
config :ef_support, EFSupport.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nfkmVqb18bxQH3cPIHhWFf8mtmizql6ec17X8r14LLInL4LgO9lttFKG3L3G2Nd7",
  render_errors: [view: EFSupport.ErrorView, accepts: ~w(html json)],
  pubsub: [name: EFSupport.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :phoenix, :format_encoders,
  "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :addict,
  secret_key: System.get_env("ADDICT_SECRET_KEY"),
  extra_validation: fn ({valid, errors}, user_params) -> {valid, errors} end, # define extra validation here
  user_schema: EFSupport.User,
  repo: EFSupport.Repo,
  from_email: "somedude@somewebsite.com",
  mailgun_domain: System.get_env("MAILGUN_DOMAIN"),
  mailgun_key: System.get_env("MAILGUN_API_KEY"),
  mail_service: :mailgun
