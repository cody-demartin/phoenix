defmodule HelloSocketsWeb.AuthSocketTest do
  use HelloSocketsWeb.ChannelCase
  import ExUnit.CaptureLog

  alias HelloSocketsWeb.AuthSocket

  defp generate_token(id, opts \\ []) do
    salt = Keyword.get(opts, :salt, "hello")
  end
end
