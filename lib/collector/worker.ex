defmodule Collector.Worker do
  use GenServer

  def start_link(_arg) do
    GenServer.start_link(KafkaEx.Server0P9P0, [
        [uris: Application.get_env(:kafka_ex, :brokers),
        consumer_group: Application.get_env(:kafka_ex, :consumer_group)],
        :no_name])
  end

  def produce(pid, data) do
    produce_request = %KafkaEx.Protocol.Produce.Request{topic: "test", partition: 0, required_acks: 0, timeout: 5000,
      compression: :none, messages: [%KafkaEx.Protocol.Produce.Message{key: "", value: data}]}
    
    GenServer.call(pid, {:produce, produce_request})
  end
end
