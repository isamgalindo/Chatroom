defmodule Task2 do
  use GenServer
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    {:ok, []} # Initial state: an empty list of subscribers
  end

  # User wants to join the chat room
  def join(pid) do
    GenServer.cast(__MODULE__, {:join, pid})
  end

  # User sends a message
  def send_message(message) do
    GenServer.cast(__MODULE__, {:message, message})
  end

  # User leaves the chat room
  def leave(pid) do
    GenServer.cast(__MODULE__, {:leave, pid})
  end

  # Server side handling
  def handle_cast({:join, pid}, subscribers) do
    {:noreply, [pid | subscribers]}
  end

  def handle_cast({:message, message}, subscribers) do
    Enum.each(subscribers, fn pid -> send(pid, {:new_message, message}) end)
    {:noreply, subscribers}
  end

  def handle_cast({:leave, pid}, subscribers) do
    {:noreply, List.delete(subscribers, pid)}
  end

end
