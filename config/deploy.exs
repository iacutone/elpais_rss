import Config

config :kamal,
  version: "0.1.0"

config :kamal, :servers,
  elpais_rss: [
    hostname: "${HETZNER_HOST}",
    username: "root"
  ]

config :kamal, :app,
  name: "elpais_rss",
  env: "prod"

# Use local builds instead of Docker registry
config :kamal, :build,
  local: true

# config :kamal, :health_check,
#   path: "/health",
#   port: 4000,
#   max_attempts: 10,
#   interval: 30

config :kamal, :env,
  AWS_ACCESS_KEY: "${AWS_ACCESS_KEY}",
  AWS_SECRET_KEY: "${AWS_SECRET_KEY}",
  EL_PAIS_RSS_URL: "${EL_PAIS_RSS_URL}",
  MAILCHIMP_API_KEY: "${MAILCHIMP_API_KEY}",
  GOOGLE_GEMINI_API_KEY: "${GOOGLE_GEMINI_API_KEY}",
  MIX_ENV: "prod" 
