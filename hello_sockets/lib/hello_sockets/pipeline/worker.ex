defmodule HelloSockets.Pipeline.Worker do
  def start_link(item) do
    Task.start_link(fn ->
      process(item)
    end)
  end

  defp process(item) do
    IO.inspect(item)
    Process.sleep(1000)
  end
end
