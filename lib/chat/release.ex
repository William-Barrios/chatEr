defmodule Chat.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :chat

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end

#defmodule Chat.Message do ... end:
#Define un módulo llamado Chat.Message.

#use Ecto.Schema:
#Esta línea indica que este módulo es un esquema Ecto, lo que implica que se utilizará para interactuar con la base de datos.

#import Ecto.Changeset:
#Importa funcionalidades para crear y manipular cambios en los datos. Los cambiosets en Ecto
#son estructuras que representan los cambios que se desean aplicar a un objeto.

#import Ecto.Query:
#Importa funcionalidades para construir consultas a la base de datos de una manera más legible y funcional.

#schema "messages" do ... end:
#Define la estructura del esquema para la tabla "messages". Aquí se especifican los campos que tendrán los mensajes en la base de datos:

#field :message, :string: Un campo llamado message que contiene texto.
#field :name, :string: Un campo llamado name que también contiene texto.
#timestamps(): Agrega campos de inserted_at y updated_at para llevar un registro de cuándo se creó y actualizó cada registro.
#@doc false:
#Indica que la documentación para el siguiente función no será generada ni mostrada.

#def changeset(message, attrs) do ... end:
#Define un método changeset/2, el cual construye un cambio o conjunto de cambios para el objeto
#message basado en los atributos attrs. Este método toma los atributos y los valida según las reglas establecidas en el esquema.

#def get_messages(limit \\ 20) do ... end:
#Define una función get_messages/1 que recupera mensajes de la base de datos.

#Chat.Message: Hace referencia al propio módulo para construir la consulta.
#limit(^limit): Limita la cantidad de mensajes recuperados según el parámetro limit (por defecto 20).
#order_by(desc: :inserted_at): Ordena los mensajes en orden descendente basado en el momento en que fueron insertados.
#Chat.Repo.all(): Realiza la consulta a la base de datos a través del repositorio Chat.Repo y devuelve todos los mensajes.
#En resumen, este módulo Chat.Message define la estructura de los mensajes en la base de datos,
#así como métodos para crear cambiosets para los mensajes y recuperar mensajes de la base de datos de manera ordenada y con límite ajustable.
