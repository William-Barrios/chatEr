defmodule ChatWeb.RoomChannel do
  use ChatWeb, :channel
  alias ChatWeb.Presence

  @impl true
  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    # Insert message in database
    {:ok, msg} = Chat.Message.changeset(%Chat.Message{}, payload) |> Chat.Repo.insert()

    # Assigning name to socket assigns and tracking presence
    socket
    |> assign(:username, msg.name)
    |> track_presence()
    |> broadcast("shout", Map.put_new(payload, :id, msg.id))

    {:noreply, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    # Get messages and list them
    Chat.Message.get_messages()
    # reverts the enum to display the latest message at the bottom of the page
    |> Enum.reverse()
    |> Enum.each(fn msg ->
      push(socket, "shout", %{
        name: msg.name,
        message: msg.message,
        inserted_at: msg.inserted_at
      })
    end)

    # Send currently online people in lobby
    push(socket, "presence_state", Presence.list("room:lobby"))

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  # This creates a Presence track when the person joins the channel.
  # Normally this is done when joining the channel,
  # but the socket doesn't know the name so we wait for a message to be sent
  # with the name to begin tracking.
  defp track_presence(%{assigns: %{username: username}} = socket) do
    Presence.track(socket, username, %{
      online_at: inspect(System.system_time(:second))
    })

    socket
  end
end

#defmodule ChatWeb.RoomChannel do ... end:
#Define el módulo ChatWeb.RoomChannel.

#use ChatWeb, :channel:
#Utiliza las funcionalidades de un canal definido en el módulo ChatWeb. Esto indica que ChatWeb.RoomChannel es un canal de comunicación Phoenix.

#alias ChatWeb.Presence:
#Crea un alias para el módulo ChatWeb.Presence para simplificar su uso en este módulo.

#@impl true def join("room:lobby", payload, socket) do ... end:
#Esta función se ejecuta cuando un cliente intenta unirse al canal "room:lobby".

#Verifica si el cliente está autorizado para unirse. Si lo está, envía un mensaje :after_join al propio
#canal y devuelve {:ok, socket}. Si no está autorizado, devuelve un error.
#@impl true def handle_in("ping", payload, socket) do ... end:
#Maneja el evento "ping" enviado por el cliente. En este caso, responde con un mensaje de confirmación "ok" al cliente.

#@impl true def handle_in("shout", payload, socket) do ... end:
#Maneja el evento "shout" enviado por el cliente, generalmente utilizado para enviar mensajes al chat.

#Crea un changeset usando los datos del mensaje recibido.
#Inserta el mensaje en la base de datos a través del Chat.Repo.
#Asigna el nombre del usuario al socket, rastrea su presencia y difunde el mensaje a todos los usuarios en el canal.
#@impl true def handle_info(:after_join, socket) do ... end:
#Se ejecuta después de que un cliente se une con éxito al canal "room:lobby".

#Obtiene los mensajes existentes en la base de datos y los envía al cliente, mostrando los últimos mensajes en la parte inferior de la página.
#Envía el estado actual de la presencia de los usuarios en la sala de chat al cliente.
#defp authorized?(_payload) do ... end:
#Función privada que simula la lógica de autorización. En este caso, siempre devuelve true, lo que permite el acceso.

#defp track_presence(%{assigns: %{username: username}} = socket) do ... end:
#Función privada que se encarga de seguir la presencia de un usuario en el canal. Registra la
#presencia del usuario en el sistema de seguimiento de presencia y asigna el nombre de usuario al socket.

#En resumen, este canal maneja la entrada de usuarios a la sala de chat, el envío de mensajes, el
#seguimiento de la presencia de usuarios y la autorización para unirse al canal, además de gestionar
#eventos específicos, como el envío y la recepción de mensajes en tiempo real.
