defmodule HumidWeb.PageController do
  use HumidWeb, :controller

  def index(conn, _params) do
    %{
      current_weather: current_weather,
      hex_commits: hex_commits,
      days_until_next_birthday: days_until_next_birthday
    } = Humid.Recur.get()

    conn
    |> assign(:hex_commits, hex_commits)
    |> assign(:current_weather, current_weather)
    |> assign(:days_until_next_birthday, days_until_next_birthday)
    |> render("index.html")
  end
end
