import Config

config :elpais_rss,
  aws_access_key: System.get_env("SES_ACCESS_KEY_ID"),
  aws_secret_key: System.get_env("SES_SECRET_ACCESS_KEY"),
  cronhub_url: System.get_env("CRONHUB_URL"),
  el_pais_rss_url: System.get_env("EL_PAIS_RSS_URL"),
  mailchimp_api_key: System.get_env("MAILCHIMP_API_KEY"),
  mailchimp_unsubscribe_endpoint: System.get_env("MAILCHIMP_UNSUBSCRIBE_ENDPOINT"),
  google_gemini_api_key: System.get_env("GOOGLE_GEMINI_API_KEY")
