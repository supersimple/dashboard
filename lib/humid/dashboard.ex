defmodule Humid.Dashboard do
  defstruct [
    :hex_commits,
    :current_weather,
    :days_until_next_birthday
  ]

  def fetch do
    github_api_key = Application.get_env(:humid, :github_personal_api_key)
    client = Tentacat.Client.new(%{access_token: github_api_key})
    currently = current_weather()
    temperature = currently["apparentTemperature"] |> Float.round(1)

    %__MODULE__{
      hex_commits: hex_commits(client),
      current_weather: temperature,
      days_until_next_birthday: days_until_next_birthday()
    }
  end

  defp hex_commits(client) do
    commits = Tentacat.Commits.filter("hexpm", "hex", %{author: "supersimple"}, client)
    length(commits)
  end

  def days_until_next_birthday do
    birthdays = [%{month: 01, day: 15}, %{month: 05, day: 04}, %{month: 09, day: 24}]
    today = Date.utc_today()
    this_year = today.year
    next_year = this_year + 1

    this_years_bdays =
      Enum.map(birthdays, fn dt ->
        {:ok, date} = Date.new(this_year, dt.month, dt.day)
        date
      end)

    next_years_bdays =
      Enum.map(birthdays, fn dt ->
        {:ok, date} = Date.new(next_year, dt.month, dt.day)
        date
      end)

    Enum.reduce(this_years_bdays ++ next_years_bdays, 366, fn dt, min ->
      if Date.diff(dt, today) < min && Date.diff(dt, today) > 0,
        do: Date.diff(dt, today),
        else: min
    end)
  end

  defp current_weather do
    darkskyx = Application.get_env(:darkskyx, :defaults)
    Darkskyx.current(darkskyx[:latitude], darkskyx[:longitude])
  end
end
