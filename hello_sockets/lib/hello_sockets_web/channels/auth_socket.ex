defmodule HelloSocketsWeb.AuthSocket do
  use Phoenix.Socket
  require Logger

  def join("user:" <> req_user_id, _payload, socket = %{assigns: %{user_id: user_id}}) do
      if req_user_id == to_string(user_id) do
        {:ok, socket}
      else
        Logger.error("#{__MODULE__} failed #{req_user_id} != #{user_id}")
        {:error, %{reason: "unauthorized"}}
      end
    end

  @one_day 86400

  channel "ping", HelloSocketsWeb.PingChannel
  channel "tracked", HelloSocketsWeb.TrackedChannel
  channel "user:*", HelloSocketsWeb.AuthChannel

    def connect(%{"token" => token}, socket) do
      case verify(socket, token) do
        {:ok, user_id} ->
          socket = assign(socket, :user_id, user_id)
          {:ok, socket}
        {:error, err} ->
          Logger.error("#{__MODULE__} connect error #{inspect(err)}")
          :error
      end
    end

    def connect(_, _socket) do
      Logger.error("#{__MODULE__} connect error missing params")
      :error
    end

    defp verify(socket, token), do: Phoenix.Token.verify(socket, "hello", token, max_age: @one_day)

    def id(%{assigns: %{user_id: user_id}}), do: "auth_socket:#{user_id}"
end
