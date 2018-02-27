defmodule HumidWeb.DashboardChannel do
  use Phoenix.Channel

  def join("dashboard:data", _message, socket) do
    {:ok, socket}
  end

  def join("dashboard:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
