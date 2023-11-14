defmodule ChatWeb.Router do
  use ChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ChatWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  # define the new pipeline using auth_plug
  pipeline :authOptional, do: plug(AuthPlugOptional)

  scope "/", ChatWeb do
    pipe_through [:browser, :authOptional]

    get "/", PageController, :home
    get "/login", AuthController, :login
    get "/logout", AuthController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatWeb do
  #   pipe_through :api
  # end
end

#Este módulo, ChatWeb.Router, es una parte fundamental de la configuración del enrutamiento
#en una aplicación Phoenix. Aquí se definen las rutas y se establecen los flujos de
#procesamiento a través de diferentes pipelines para solicitudes HTTP específicas.

#Se define un pipeline denominado :browser, el cual se encarga de gestionar las
#solicitudes provenientes del navegador. Este pipeline configura aspectos como el manejo
# de sesiones, protección contra CSRF (Cross-Site Request Forgery) y encabezados de seguridad del navegador.

#Se define un pipeline denominado :authOptional, el cual utiliza un módulo denominado AuthPlugOptional
#. Esto probablemente se utiliza para permitir el acceso a ciertas rutas sin requerir autenticación.

#Se establece un alcance (scope) para las rutas. Dentro de este alcance, se especifican las rutas
# a diferentes controladores y acciones correspondientes. Por ejemplo:

#La ruta raíz ("/") está vinculada a PageController y a la acción :home.
#Las rutas "/login" y "/logout" están vinculadas al controlador AuthController y a las acciones :login y :logout respectivamente.
#Se comenta la configuración de un posible pipeline para rutas de tipo API, lo que sugiere una estructura para manejar solicitudes y respuestas de tipo JSON.

#En resumen, este módulo ChatWeb.Router establece cómo las solicitudes HTTP se gestionan y
# se enrutan en la aplicación Phoenix, definiendo qué acciones se toman y qué controladores
# manejan estas acciones en respuesta a las solicitudes del navegador o de la API.
