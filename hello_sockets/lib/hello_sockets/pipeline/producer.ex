defmodule HelloSockets.Pipeline.Producer do
  use GenStage

  def start_link(opts) do
    {[name: name], opts} = Keyword.split(opts, [:name])
    GenStage.start_link(__MODULE__, opts, name: name)
  end

  # returns a tuple to let GenStage know we are returning a producer
  def init(_opts) do
    {:producer, :unused, buffer_size: 10_000}
  end

  # not doing anything because in this case, the internal buffer manages data flow
  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end

  # use GenStage.cast/2 in order to cast a message to our producer process
  def push(item = %{}) do
    GenStage.cast(__MODULE__, {:notify, item})

  end

  # returns a tuple that includes the item in a list
  def handle_cast({:notify, item}, state) do
    {:noreply, [%{item: item}], state}
  end

  # gen stage will take the items and either sends them out or buffers them in memory

end
