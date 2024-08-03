defmodule Portfolio.Messaging do
  def subscribe(topic) do
    Phoenix.PubSub.subscribe(Portfolio.PubSub, topic)
  end

  def notify_subscribers(value, topic, event) do
    Phoenix.PubSub.broadcast(Portfolio.PubSub, topic, {event, value})
  end
end
