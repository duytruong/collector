defmodule Collector.Worker do
  use GenServer

  def start_link(_arg) do
    GenServer.start_link(KafkaEx.Server0P9P0, [
        [uris: Application.get_env(:kafka_ex, :brokers),
        consumer_group: Application.get_env(:kafka_ex, :consumer_group)],
        :no_name])
  end

  def produce(pid, data) do
    encoder = Collector.AvroEncoder.get_encoder
    metric = data["metric"]
    encoded = create_avro_message(metric, encoder[metric], data)
    
    produce_request = %KafkaEx.Protocol.Produce.Request{topic: metric, partition: 0, required_acks: 0, timeout: 5000,
      compression: :none, messages: [%KafkaEx.Protocol.Produce.Message{key: nil, value: encoded}]}
    
    GenServer.call(pid, {:produce, produce_request})
  end

  #TODO: create a function generates a list of 2-tuples so that we can check field exist or not

  def create_avro_message("click", encoder, data) do
    :erlang.iolist_to_binary(encoder.("clickevent",
      [{<<"metric">>, <<data["metric"]::binary>>}, {<<"uuid">>, <<data["uuid"]::binary>>},
       {<<"location">>, <<data["location"]::binary>>}, {<<"referrer">>, <<data["referrer"]::binary>>},
       {<<"url">>, <<data["url"]::binary>>}, {<<"product">>, <<data["product"]::binary>>},
       {<<"video">>, <<data["video"]::binary>>} ]))
  end

  def create_avro_message("order", encoder, data) do
    viewer = if data["viewer"] do String.to_integer(data["viewer"]) else -1 end
    order = if data["order"] do String.to_integer(data["order"]) else -1 end
    :erlang.iolist_to_binary(encoder.("orderevent",
      [{<<"metric">>, <<data["metric"]::binary>>}, {<<"uuid">>, <<data["uuid"]::binary>>},
       {<<"location">>, <<data["location"]::binary>>}, {<<"referrer">>, <<data["referrer"]::binary>>},
       {<<"url">>, <<data["url"]::binary>>}, {<<"product">>, <<data["product"]::binary>>},
       {<<"video">>, <<data["video"]::binary>>}, {<<"viewer">>, viewer}, {<<"order">>, order} ]))
  end

  @doc """
  Encode message in Avro format, if a field in message is not exist, -1 will be used in output.
  """
  def create_avro_message("pageview", encoder, data) do
    viewer = if data["viewer"] do String.to_integer(data["viewer"]) else -1 end
    :erlang.iolist_to_binary(encoder.("pageviewevent",
      [{<<"metric">>, <<data["metric"]::binary>>}, {<<"uuid">>, <<data["uuid"]::binary>>},
       {<<"location">>, <<data["location"]::binary>>}, {<<"referrer">>, <<data["referrer"]::binary>>},
       {<<"url">>, <<data["url"]::binary>>}, {<<"product">>, <<data["product"]::binary>>},
       {<<"video">>, <<data["video"]::binary>>}, {<<"viewer">>, viewer} ]))
  end
end
