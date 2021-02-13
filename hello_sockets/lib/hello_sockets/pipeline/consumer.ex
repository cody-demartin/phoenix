defmodule HelloSockets.Pipeline.Consumer do
  use GenStage

  def start_link(opts) do
    GenStage.start_link(__MODULE__, opts)
  end

  # letting genstage know that this is a consumer and that it will need to sub
  # to a producer

  # every consumer must have lambda function to handle items
  def init(opts) do
    subscribe_to =
      Keyword.get(opts, :subscribe_to, HelloSockets.Pipeline.Producer)
    {:consumer, :unused, subscribe_to: subscribe_to}
  end

  # handle event lamda receives multiple items at once, must always treat as list
  # all we are doing is logging them for now to see how it dispatches
  def handle_events(items, _from, state) do
    IO.inspect({__MODULE__, length(items), List.first(items), List.last(items)})

    {:noreply, [], state}
  end


end
