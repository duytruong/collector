defmodule Collector.AvroEncoder do
    use GenServer

    def start_link do
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init(_arg) do
      path_to_schema = Application.app_dir(:collector, "priv/schema//")
      click_store = :avro_schema_store.new([], [path_to_schema <> "click.avsc"])
      order_store = :avro_schema_store.new([], [path_to_schema <> "order.avsc"])
      view_store = :avro_schema_store.new([], [path_to_schema <> "pageview.avsc"])
      click_encoder = :avro.make_encoder(click_store, [])
      order_encoder = :avro.make_encoder(order_store, [])
      view_encoder = :avro.make_encoder(view_store, [])
      {:ok, %{"click" => click_encoder, "order" => order_encoder, "pageview" => view_encoder}}
    end

    def handle_call(:get_encoder, _from, encoder) do
      {:reply, encoder, encoder}
    end

    def get_encoder do
      GenServer.call(__MODULE__, :get_encoder)
    end
    
end
