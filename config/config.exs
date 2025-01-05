import Config

config :elpais_rss, ElpaisRss.Scheduler,
  jobs: [
    # Every day at noon ET (17 UTC)
    {"0 17 * * *", {ElpaisRss, :run, []}}
  ]
