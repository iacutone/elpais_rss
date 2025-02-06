import Config

config :elpais_rss, ElpaisRss.Scheduler,
  jobs: [
    # Every day at noon ET (17 UTC)
    {"0 17 * * *", {ElpaisRss, :run, []}},
    # every 15 minutes
    {"*/5 * * * *", fn -> Goth.fetch!(ElpaisRss.Goth) end}
  ]
