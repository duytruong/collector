defmodule Collector.AvroEncoder do
    use GenServer

    def start_link do
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init(_arg) do
      click_store = :avro_schema_store.new([], ["schema/click.avsc"])
      order_store = :avro_schema_store.new([], ["schema/order.avsc"])
      view_store = :avro_schema_store.new([], ["schema/pageview.avsc"])
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
