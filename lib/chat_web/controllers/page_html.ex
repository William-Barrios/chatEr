defmodule ChatWeb.PageHTML do
  use ChatWeb, :html

  embed_templates "page_html/*"

  def person_name(person) do
    person.givenName || person.name || "guest"
  end
end

#Este módulo ChatWeb.PageHTML es una vista en Phoenix, específicamente para la generación
# de HTML. Está utilizando plantillas embebidas ubicadas en el directorio page_html/*.

#Dentro de esta vista, hay una función person_name/1, que toma un parámetro person.
# Esta función intenta obtener el nombre de la persona desde su nombre dado (givenName)
# o simplemente desde el campo name. Si ninguno de estos campos está presente o son
#nulos en la estructura person, se devuelve la cadena "guest".
