# SystemInfo
Utilidad para mostrar información del sistema en linea de comandos, graficamente. Cambia el fondo de pantalla

Uso: systeminfo.exe [opciones]

Opciones:

  pantalla      Muestra la información del sistema en una ventana.
  
  setfondo      Configura la imagen del sistema como fondo de pantalla directamente sin confirmación.
  
  texto <size>  Cambia el tamaño del texto en la imagen del fondo de pantalla.
  
  color <hex>   Cambia el color del texto en la imagen del fondo de pantalla. Ejemplo de color en hex: FF0000 para rojo.

  /?            Muestra esta ayuda.
  
  /e            Cambia el idioma de los mensajes a inglés.

Ejemplos:

  systeminfo.exe pantalla
  systeminfo.exe setfondo
  systeminfo.exe texto 12
  systeminfo.exe color FF0000
