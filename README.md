# SystemInfo

Utilidad para mostrar información del sistema en línea de comandos, gráficamente. Cambia el fondo de pantalla activo, respentando el existente.

Permite cambiar el fondo de pantalla con la información del sistema (respetando el existente), temperatura de la cpu, uso disco, núcleos, modelo, memoria, etc.

También admite modo consola con parámetros tanto en castellano como inglés, personalización de color y tamaño de texto.

Puedes contribuir con el proyecto mejorando el script. 

Gracias.

----------------------------

Utility to display system information in the command line, graphically. Changes the active wallpaper, respecting the existing one.

Allows you to change the wallpaper with system information (respecting the existing one), CPU temperature, disk usage, cores, model, memory, etc.

It also supports console mode with parameters in both Spanish and English, and customization of color and text size.

You can contribute to the project by improving the script.

Thank you.
Oscar de la Cuesta - www.palentino.es



Uso: systeminfo.exe [opciones]

**Opciones**:

  **pantalla**      Muestra la información del sistema en una ventana.
  
  **setfondo**      Configura la imagen del sistema como fondo de pantalla directamente sin confirmación.
  
  **texto <size>**  Cambia el tamaño del texto en la imagen del fondo de pantalla.
  
  **color <hex>**   Cambia el color del texto en la imagen del fondo de pantalla. Ejemplo de color en hex: FF0000 para rojo.

  **/?**            Muestra esta ayuda.
  
  **/e**            Cambia el idioma de los mensajes a inglés.

Ejemplos:

  systeminfo.exe pantalla

  systeminfo.exe setfondo

  systeminfo.exe texto 12

  systeminfo.exe color FF0000
