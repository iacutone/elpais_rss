import Config

config :elpais_rss, ElpaisRss.Scheduler,
  jobs: [
    # Every day at noon
    {"0 12 * * *", {ElpaisRss, :run, []}}
  ]
