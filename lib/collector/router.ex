defmodule Collector.Router do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn = fetch_query_params(conn)
    query_params = conn.query_params
    :poolboy.transaction(:kafka_workers, fn(pid) -> Collector.Worker.produce(pid, query_params) end)
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "OK")
  end
  
end
