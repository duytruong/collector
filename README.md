# Collector

A HTTP log collector written in Elixir

## Prerequisite

- [Apache Kafka](http://kafka.apache.org/)
- A log generator if you're in development, I use [this](https://github.com/rfxlab/vidsell-data-simulator), create your own if you want.

## Configuration

See [config/config.exs](https://github.com/duytruong/collector/blob/master/config/config.exs) or [KafkaEx.Config](https://hexdocs.pm/kafka_ex/KafkaEx.Config.html) for configurations of Kafka client.

See [Raising the Maximum Number of File Descriptors](https://underyx.me/2015/05/18/raising-the-maximum-number-of-file-descriptors) if you have a problem when create too many workers in pool.

## TODO

- [ ] Produce messages in batch
- [ ] Deployment guide