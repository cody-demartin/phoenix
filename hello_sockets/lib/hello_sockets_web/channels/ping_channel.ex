defmodule HelloSocketsWeb.PingChannel do
  use Phoenix.Channel

  def join(_topic, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("ping:" <> phrase, _payload, socket) do
    {:reply, {:ok, %{ping: phrase}}, socket}
  end

  def handle_in("ping", %{"ack_phrase" => ack_phrase}, socket) do
    {:reply, {:ok, %{ping: ack_phrase}}, socket}
  end

  def handle_in("ping", _payload, socket) do
    {:reply, {:ok, %{ping: "pong"}}, socket}
  end

  def handle_in("pong", _payload, socket) do
    # only handle the ping

    {:noreply, socket}
  end

  def handle_in("ding", _payload, socket) do
    {:stop, :shutdown, {:ok, %{msg: "shutting down"}}, socket}
  end

  def handle_out("Request_ping", payload, socket) do
    push(socket, "Send_ping", Map.put(payload, "from_node", Node.self()))
    {:noreply, socket}
  end
end
