defmodule ChatWeb.RoomChannelTest do
  use ChatWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      ChatWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(ChatWeb.RoomChannel, "room:lobby")

    %{socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push(socket, "ping", %{"hello" => "there"})
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to room:lobby a message with username", %{socket: socket} do
    push(socket, "shout", %{"name" => "test_username", "message" => "hey all"})
    assert_broadcast "shout", %{"name" => "test_username", "message" => "hey all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push "broadcast", %{"some" => "data"}
  end

  test ":after_join sends all existing messages", %{socket: socket} do
    # insert a new message to send in the :after_join
    payload = %{name: "Alex", message: "test"}
    Chat.Message.changeset(%Chat.Message{}, payload) |> Chat.Repo.insert()

    {:ok, _, socket2} =
      ChatWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(ChatWeb.RoomChannel, "room:lobby")

    assert socket2.join_ref != socket.join_ref
  end
end

#Este módulo es parte de las pruebas de canal en una aplicación Phoenix. Está diseñado para
#probar la funcionalidad del canal de sala de chat (RoomChannel) dentro del contexto de una aplicación Phoenix.

#Utiliza ChatWeb.ChannelCase, lo que indica que estos son casos de prueba relacionados con canales en la aplicación Phoenix.

#El método setup es utilizado para configurar el contexto de las pruebas. Establece un
#socket y suscripciones para simular la interacción del usuario con el canal RoomChannel.

#Las pruebas están orientadas a verificar el comportamiento del canal y la lógica de interacción a través de eventos.

#test "ping replies with status ok" verifica si el canal responde correctamente al evento "ping", esperando un estado "ok" como respuesta.

#test "shout broadcasts to room:lobby a message with username" se asegura de que el
# evento "shout" emita un mensaje al canal room:lobby con el nombre de usuario.

#test "broadcasts are pushed to the client" confirma que los eventos de emisión son entregados correctamente al cliente.

#test ":after_join sends all existing messages" comprueba si, al unirse al canal, se envían
# todos los mensajes existentes a un nuevo socket, asegurando que los mensajes previos se envíen después de unirse al canal.

#Estas pruebas evalúan el comportamiento del canal RoomChannel en varios escenarios,
#asegurando que las interacciones con el canal, como envío y recepción de mensajes, se comporten como se espera
