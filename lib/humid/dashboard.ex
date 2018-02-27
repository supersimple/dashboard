defmodule Humid.Dashboard do
  defstruct [
    :hex_commits,
    :hex_ranking,
    :online_order_commits,
    :open_prs,
    :days_until_next_meetup,
    :current_weather
  ]

  def fetch do
    github_api_key = Application.get_env(:humid, :github_personal_api_key)
    client = Tentacat.Client.new(%{access_token: github_api_key})
    currently = current_weather()
    temperature = currently["apparentTemperature"] |> Float.round(1)

    %__MODULE__{
      hex_commits: hex_commits(client),
      hex_ranking: hex_ranking(client),
      online_order_commits: online_order_commits(client),
      open_prs: open_prs(client),
      days_until_next_meetup: days_until_next_meetup(),
      current_weather: temperature
    }
  end

  defp hex_commits(client) do
    commits = Tentacat.Commits.filter("hexpm", "hex", %{author: "supersimple"}, client)
    length(commits)
  end

  defp hex_ranking(client) do
    Tentacat.Repositories.Contributors.list("hexpm", "hex", client)
    |> Enum.find_index(fn con -> con["login"] == "supersimple" end)
    |> Kernel.+(1)
  end

  defp online_order_commits(client) do
    commits =
      Tentacat.Commits.filter(
        "GhostGroup",
        "platform",
        %{author: "supersimple"},
        client
      )

    length(commits)
  end

  defp open_prs(client) do
    pull_requests =
      Tentacat.Pulls.filter(
        "GhostGroup",
        "platform",
        %{state: "open", author: "supersimple"},
        client
      )

    length(pull_requests)
  end

  defp days_until_next_meetup do
    url =
      "https://api.meetup.com/Denver-Erlang-Elixir/events?&sign=true&key=6879b3e142ea2c177b6c49465b185&photo-host=public&page=1"

    response = HTTPotion.get(url)

    first_result =
      response.body
      |> Poison.decode!()
      |> List.first()

    days_between(first_result["time"])
  end

  defp days_between(event_time) do
    diff = event_time / 1000 - (DateTime.utc_now() |> DateTime.to_unix())
    (diff / 60 / 60 / 24) |> Kernel.trunc()
  end

  defp current_weather do
    darkskyx = Application.get_env(:darkskyx, :defaults)
    Darkskyx.current(darkskyx[:latitude], darkskyx[:longitude])
  end
end
