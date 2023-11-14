defmodule ChatWeb.Presence do
  use Phoenix.Presence,
    otp_app: :chat,
    pubsub_server: Chat.PubSub
end
#Este módulo, ChatWeb.Presence, se encarga de gestionar la presencia de los usuarios
#en tiempo real. Hace uso de la funcionalidad de presencia de Phoenix para rastrear qué
#usuarios están conectados y en qué momento. Algunas de las funciones clave que ofrece
#Phoenix Presence son la capacidad de rastrear usuarios en canales de chat, recibir
#actualizaciones cuando se unen o abandonan canales, y distribuir esa información a todos
# los clientes conectados. En este caso, está configurado para utilizar Chat.PubSub como
#su servidor PubSub para la gestión de canales de presencia.
