defmodule Task2 do
  def start do
    spawn_link(fn -> loop(%{users: []}) end)
  end

  defp loop(state) do
    receive do
      {:join, user_id} ->
        IO.puts("El usuario #{inspect(user_id)} se unió al chatroom")
        loop(%{state | users: state.users ++ [user_id]})

      {:leave, user_id} ->
        IO.puts("El ususario #{inspect(user_id)} salió del chatroom")
        loop(%{state | users: Enum.reject(state.users, &(&1 == user_id))})

      {:send_message, user_id, message} ->
        Enum.each(state.users, fn id -> send(id, {:new_message, user_id, message}) end)
        IO.puts("El usuario #{inspect(user_id)} envió: #{message}")
        loop(state)

      {:get_users, caller} ->
        send(caller, {:users, state.users})
        loop(state)
    end
  end

  def join(chat_room) do
    send(chat_room, {:join, self()})
  end

  def leave(chat_room) do
    send(chat_room, {:leave, self()})
  end

  def send_message(chat_room, message) do
    send(chat_room, {:send_message, self(), message})
  end

  def get_users(chat_room) do
    send(chat_room, {:get_users, self()})
    receive do
      {:users, users} -> users
    end
end

end
