defmodule Chat.Application do #define un modulo

  #Un atributo que indica que la documentación del módulo
  #no se va a generar ni mostrar. Esto puede ser útil
  #cuando se quiere ocultar la documentación de un módulo.
  @moduledoc false
  #Este módulo hace uso de funcionalidades y comportamientos
  # específicos proporcionados por el módulo Application de Elixir.
  #Esto es común en la definición de aplicaciones Elixir.
  use Application

  @impl true #Es la implementacion de la funcion de start/2 que
  #es requerida por el comportamiento "Application". Esta funcion se
  #ejecuta cuando la aplicacion se inicia
  def start(_type, _args) do
    children = [

      ChatWeb.Telemetry,

      Chat.Repo,

      {Phoenix.PubSub, name: Chat.PubSub},
      ChatWeb.Presence,

      ChatWeb.Endpoint

    ]

    opts = [strategy: :one_for_one, name: Chat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    ChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
