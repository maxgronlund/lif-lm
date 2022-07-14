# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :run,
  ecto_repos: [Run.Repo]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :run, Run.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

config :run_web,
  ecto_repos: [Run.Repo],
  generators: [context_app: :run, binary_id: true]

# Configures the endpoint
config :run_web, RunWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: RunWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Run.PubSub,
  live_view: [signing_salt: "xR0e5+36"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/run_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Tailwind
config :tailwind,
  version: "3.0.24",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/run_web/assets", __DIR__)
  ]

# Configures BasicAuth
config :run, :basic_auth,
  username: System.get_env("AUTH_USERNAME"),
  password: System.get_env("AUTH_PASSWORD")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :arc,
  storage: Arc.Storage.S3,
  virtual_host: true,
  # if using Amazon S3
  bucket: System.get_env("AOFF_AWS_S3_BUCKET")

config :ex_aws,
  access_key_id: System.get_env("AOFF_AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AOFF_AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AOFF_AWS_REGION"),
  s3: [
    scheme: "https://",
    host: "s3." <> System.get_env("AOFF_AWS_REGION") <> ".amazonaws.com",
    region: System.get_env("AOFF_AWS_REGION")
  ]

# Set default locale to da
config :gettext, :default_locale, "da"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
