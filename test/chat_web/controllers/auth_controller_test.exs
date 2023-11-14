defmodule ChatWeb.AuthControllerTest do
  use ChatWeb.ConnCase, async: true

  test "Logout link displayed when loggedin", %{conn: conn} do
    data = %{email: "test@dwyl.com", givenName: "Simon", picture: "this", auth_provider: "GitHub"}
    jwt = AuthPlug.Token.generate_jwt!(data)

    conn = get(conn, "/?jwt=#{jwt}")
    assert html_response(conn, 200) =~ "logout"
  end

  test "get /logout with valid JWT", %{conn: conn} do
    data = %{
      email: "al@dwyl.com",
      givenName: "Al",
      picture: "this",
      auth_provider: "GitHub",
      sid: 1,
      id: 1
    }

    jwt = AuthPlug.Token.generate_jwt!(data)

    conn =
      conn
      |> put_req_header("authorization", jwt)
      |> get("/logout")

    assert "/" = redirected_to(conn, 302)
  end

  test "test login link redirect to authdemo.fly.dev", %{conn: conn} do
    conn = get(conn, "/login")
    assert redirected_to(conn, 302) =~ "authdemo.fly.dev"
  end
end

#Este módulo contiene pruebas para el controlador de autenticación (AuthController) de una aplicación Phoenix.

#Utiliza ChatWeb.ConnCase, lo que indica que son pruebas relacionadas con las conexiones HTTP en la aplicación Phoenix.
#async: true sugiere que estas pruebas se ejecutan de forma asíncrona.
#Vamos a revisar las pruebas:

#test "Logout link displayed when loggedin" verifica si el enlace de cierre de sesión se muestra
#correctamente cuando un usuario está autenticado. Utiliza un token JWT (JSON Web Token) generado
  # y lo adjunta a la solicitud HTTP. Luego, verifica que la respuesta HTML incluya el texto "logout" como parte del enlace para cerrar sesión.

#test "get /logout with valid JWT" evalúa el comportamiento de cerrar sesión (/logout)
# cuando se le proporciona un JWT válido. Genera un JWT y lo agrega al encabezado de la
#solicitud, simula la petición de cierre de sesión y asegura que la redirección después de cerrar sesión sea a la ruta raíz del sistema.

#test "test login link redirect to authdemo.fly.dev" examina si el enlace de inicio de sesión
#(/login) redirige correctamente a un dominio externo. Realiza una solicitud a /login y verifica que la redirección apunte a "authdemo.fly.dev".

#Estas pruebas se centran en la funcionalidad de autenticación y cerrar sesión de la aplicación, asegurando que los enlaces y redirecciones funcionen según lo previsto.
