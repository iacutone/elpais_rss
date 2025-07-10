import Config

config :elpais_rss, ElpaisRss.Scheduler,
  jobs: [
    # Every day at noon ET (17 UTC)
    {"0 17 * * *", {ElpaisRss, :run, []}}
  ]

config :elpais_rss,
  aws_access_key: System.get_env("AWS_ACCESS_KEY"),
  aws_secret_key: System.get_env("AWS_SECRET_KEY"),
  el_pais_rss_url: System.get_env("EL_PAIS_RSS_URL"),
  mailchimp_api_key: System.get_env("MAILCHIMP_API_KEY"),
  google_gemini_api_key: System.get_env("GOOGLE_GEMINI_API_KEY")
