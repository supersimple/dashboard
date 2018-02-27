defmodule Humid.Recur do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    dashboard = Humid.Dashboard.fetch()
    schedule_work()
    {:ok, dashboard}
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:work, _state) do
    dashboard = Humid.Dashboard.fetch()
    HumidWeb.Endpoint.broadcast("dashboard:data", "new_data", dashboard)
    schedule_work()
    {:noreply, dashboard}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 15 * 60 * 1000)
  end
end
