defmodule HumidWeb.PageControllerTest do
  use HumidWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "HUMID ☁️"
  end
end
