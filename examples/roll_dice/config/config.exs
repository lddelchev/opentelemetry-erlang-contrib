# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :roll_dice, RollDiceWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: RollDiceWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: RollDice.PubSub,
  live_view: [signing_salt: "F/DlUt0K"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :opentelemetry,
       resource: %{service: %{name: "roll_dice_app"}},
       span_processor: :batch,
       traces_exporter: :otlp,
       metrics_exporter: :otlp

config :opentelemetry_exporter,
       otlp_protocol: :grpc,
       otlp_endpoint: "http://localhost:4317"

config :opentelemetry_experimental, :readers,
  [%{
    module: :otel_metric_reader,
    config: %{
      exporter: {:otel_metric_exporter_pid, {:metric, self()}},
      default_temporality_mapping: %{
        counter: :temporality_delta,
        observable_counter: :temporality_cumulative,
        updown_counter: :temporality_delta,
        observable_updowncounter: :temporality_cumulative,
        histogram: :temporality_cumulative,
        observable_gauge: :temporality_cumulative
      }
    }
  }]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
