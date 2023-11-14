defmodule ChatWeb.AuthController do
  use ChatWeb, :controller

  def login(conn, _params) do
    redirect(conn, external: AuthPlug.get_auth_url(conn, "/"))
  end

  def logout(conn, _params) do
    conn
    |> AuthPlug.logout()
    |> put_status(302)
    |> redirect(to: "/")
  end
end

#login/2: Esta función se encarga de redirigir al usuario a una URL de autenticación.
#Usa AuthPlug.get_auth_url/2 para obtener la URL y luego redirige al usuario a esa URL.
#La URL de redirección podría ser a un servicio externo de autenticación o a un formulario de inicio de sesión.

#logout/2: Esta función maneja la acción de cerrar sesión. Primero, realiza una operación
#de logout utilizando AuthPlug.logout/1, que probablemente limpia las credenciales de
#autenticación o realiza alguna acción relacionada con el cierre de sesión. Luego, establece
# el estado de la respuesta a 302 (redirección temporal) y redirige al usuario de vuelta a la página principal ("/").
