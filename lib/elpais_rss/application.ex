defmodule ElpaisRss.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    credentials =
      "GOOGLE_APPLICATION_CREDENTIALS_JSON"
      |> System.fetch_env!()
      |> File.read!()
      |> Jason.decode!()

    source = {:service_account, credentials}

    children = [
      {Goth, name: ElpaisRss.Goth, source: source},
      ElpaisRss.Scheduler
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
