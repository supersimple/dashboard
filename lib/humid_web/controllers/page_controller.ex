defmodule HumidWeb.PageController do
  use HumidWeb, :controller

  def index(conn, _params) do
    %{
      current_weather: current_weather,
      days_until_next_meetup: days_until_next_meetup,
      hex_commits: hex_commits,
      hex_ranking: hex_ranking,
      online_order_commits: online_order_commits,
      open_prs: open_prs,
      days_until_next_birthday: days_until_next_birthday
    } = Humid.Recur.get()

    conn
    |> assign(:hex_commits, hex_commits)
    |> assign(:hex_ranking, hex_ranking)
    |> assign(:online_order_commits, online_order_commits)
    |> assign(:open_prs, open_prs)
    |> assign(:days_until_next_meetup, days_until_next_meetup)
    |> assign(:current_weather, current_weather)
    |> assign(:days_until_next_birthday, days_until_next_birthday)
    |> render("index.html")
  end
end
