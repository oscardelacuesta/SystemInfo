# Créditos: Oscar de la Cuesta, www.palentino.es

Add-Type -AssemblyName System.Windows.Forms

# Variable para definir el idioma (por defecto en español)
$language = "es"

# Verificar si se pasó el parámetro /e para cambiar a inglés
if ($args[0] -eq "/e") {
    $language = "en"
}

# Función para mostrar la ayuda
function Show-Help {
    if ($language -eq "es") {
        $helpText = @"
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
"@
    } else {
        $helpText = @"
Usage: systeminfo.exe [options]

Options:
  pantalla      Shows system information in a window.
  setfondo      Sets the system information image as wallpaper directly without confirmation.
  texto <size>  Changes the text size in the wallpaper image.
  color <hex>   Changes the text color in the wallpaper image. Example color in hex: FF0000 for red.
  /?            Shows this help message.
  /e            Changes the message language to English.

Examples:
  systeminfo.exe pantalla
  systeminfo.exe setfondo
  systeminfo.exe texto 12
  systeminfo.exe color FF0000
"@
    }
    Write-Host $helpText
}

# Mostrar ayuda si se ejecuta con el parámetro '/?' o '/e'
if ($args[0] -eq "/?" -or ($args[0] -eq "/e" -and $args.Length -eq 1)) {
    Show-Help
    exit
}

# Función para mostrar la información en una ventana
function Show-InfoWindow {
    param (
        [string]$infoText
    )
    $form = New-Object System.Windows.Forms.Form
    $form.Text = if ($language -eq "es") { "Información del Sistema" } else { "System Information" }
    $form.Size = New-Object System.Drawing.Size(600, 400)
    
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Multiline = $true
    $textBox.Dock = [System.Windows.Forms.DockStyle]::Fill
    $textBox.Text = $infoText
    $textBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
    $textBox.ReadOnly = $true

    $form.Controls.Add($textBox)
    $form.ShowDialog()
}

# Obtener información del procesador, memoria, GPU y disco
$processorInfo = Get-WmiObject -Class Win32_Processor
$memoryInfo = Get-WmiObject -Class Win32_PhysicalMemory
$computerSystem = Get-WmiObject -Class Win32_ComputerSystem
$gpuInfo = Get-WmiObject -Class Win32_VideoController
$diskInfo = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'"

# Obtener detalles del procesador
$processorSpeed = $processorInfo.MaxClockSpeed
$numberOfCores = $processorInfo.NumberOfCores
$numberOfLogicalProcessors = $processorInfo.NumberOfLogicalProcessors
$processorName = $processorInfo.Name
$processorArchitecture = $processorInfo.AddressWidth
$processorDescription = $processorInfo.Description
$processorManufacturer = $processorInfo.Manufacturer
$processorStatus = $processorInfo.Status
$processorRevision = $processorInfo.Revision

# Obtener detalles de la memoria
$totalMemory = ($memoryInfo | Measure-Object -Property Capacity -Sum).Sum / 1GB
$maxSupportedMemory = [math]::round($computerSystem.TotalPhysicalMemory / 1GB, 2)

# Obtener detalles de la GPU
$gpuDetails = foreach ($gpu in $gpuInfo) {
    $gpuName = $gpu.Name
    $gpuMemory = [math]::round(($gpu.AdapterRAM / 1GB), 2)
    "GPU: $gpuName, Memoria GPU: $gpuMemory GB"
}

# Obtener detalles del disco
$diskSize = [math]::round($diskInfo.Size / 1GB, 2)
$diskFreeSpace = [math]::round($diskInfo.FreeSpace / 1GB, 2)
$diskUsedSpace = $diskSize - $diskFreeSpace

# Obtener la temperatura del procesador
try {
    $temperatureInfo = Get-WmiObject -Namespace "root\wmi" -Class MSAcpi_ThermalZoneTemperature
    $temperatureCelsius = ($temperatureInfo.CurrentTemperature - 2732) / 10
}
catch {
    $temperatureCelsius = "N/A"
}

# Obtener el número de ranuras de memoria
$memoryDevices = Get-WmiObject -Class Win32_PhysicalMemoryArray
$memorySlots = $memoryDevices | Measure-Object -Property MemoryDevices -Sum

# Obtener detalles de los módulos de memoria
$memoryDetails = foreach ($memory in $memoryInfo) {
    $memoryCapacity = [math]::round($memory.Capacity / 1GB, 2)
    "Módulo: $($memory.DeviceLocator) - Modelo: $($memory.PartNumber) - Capacidad: $memoryCapacity GB - Velocidad: $($memory.Speed) MHz - Fabricante: $($memory.Manufacturer)"
}

# Obtener el nombre de la máquina
$computerName = $computerSystem.Name

# Obtener la IP actual en uso
$ipAddress = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.PrefixOrigin -ne 'WellKnown' }).IPAddress

# Crear la cadena de texto con la información
if ($language -eq "es") {
    $infoText = @"
Créditos: Oscar de la Cuesta, www.palentino.es
---
Nombre de la máquina: $computerName
IP actual en uso: $ipAddress
Velocidad del procesador: $processorSpeed MHz
Número de núcleos: $numberOfCores
Número de hilos (Logical Processors): $numberOfLogicalProcessors
Nombre del procesador: $processorName
Arquitectura del procesador: $processorArchitecture-bit
Descripción del procesador: $processorDescription
Fabricante del procesador: $processorManufacturer
Estado del procesador: $processorStatus
Revisión del procesador: $processorRevision
Memoria RAM instalada: $totalMemory GB
Memoria RAM máxima soportada: $maxSupportedMemory GB
Temperatura del procesador: $temperatureCelsius °C
Número de ranuras de memoria RAM: $memorySlots
Detalles de los módulos de memoria:
$($memoryDetails -join "`n")
---
$($gpuDetails -join "`n")
---
Disco Principal (C:): $diskSize GB
Espacio Usado: $diskUsedSpace GB
Espacio Libre: $diskFreeSpace GB
"@
} else {
    $infoText = @"
Credits: Oscar de la Cuesta, www.palentino.es
---
Computer Name: $computerName
Current IP: $ipAddress
Processor Speed: $processorSpeed MHz
Number of Cores: $numberOfCores
Number of Threads (Logical Processors): $numberOfLogicalProcessors
Processor Name: $processorName
Processor Architecture: $processorArchitecture-bit
Processor Description: $processorDescription
Processor Manufacturer: $processorManufacturer
Processor Status: $processorStatus
Processor Revision: $processorRevision
Installed RAM: $totalMemory GB
Maximum Supported RAM: $maxSupportedMemory GB
Processor Temperature: $temperatureCelsius °C
Number of RAM Slots: $memorySlots
RAM Module Details:
$($memoryDetails -join "`n")
---
$($gpuDetails -join "`n")
---
Main Disk (C:): $diskSize GB
Used Space: $diskUsedSpace GB
Free Space: $diskFreeSpace GB
"@
}

# Mostrar los datos recopilados
Write-Host $infoText

# Mostrar información en una ventana si se ejecuta con el parámetro 'pantalla'
if ($args[0] -eq "pantalla") {
    Show-InfoWindow -infoText $infoText
    exit
}

# Función para establecer el fondo de pantalla
function Set-Wallpaper {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
namespace Win32 {
    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
}
"@
    [Win32.Wallpaper]::SystemParametersInfo(0x0014, 0, $Path, 0x0001)
}

# Función para crear la imagen con la información del sistema
function Create-Wallpaper {
    param (
        [int]$fontSize = 10,
        [string]$fontColor = "FFFFFF" # Color por defecto: blanco
    )

    $screenWidth = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width
    $screenHeight = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height

    # Ruta de la imagen de fondo actual
    Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Text;
public class Wallpaper {
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, StringBuilder lpvParam, int fuWinIni);
    public static string GetWallpaper() {
        const int SPI_GETDESKWALLPAPER = 0x0073;
        StringBuilder sb = new StringBuilder(200);
        SystemParametersInfo(SPI_GETDESKWALLPAPER, sb.Capacity, sb, 0);
        return sb.ToString();
    }
}
"@
    $wallpaperPath = [Wallpaper]::GetWallpaper()
    
    # Validar la ruta de la imagen de fondo actual
    if (-not [System.IO.File]::Exists($wallpaperPath)) {
        $wallpaperPathMessage = if ($language -eq "es") { "La ruta del fondo de pantalla actual no es válida. Usando fondo de pantalla por defecto." } else { "The current wallpaper path is not valid. Using default wallpaper." }
        Write-Host $wallpaperPathMessage
        $wallpaperPath = "$env:SystemRoot\Web\Wallpaper\Windows\img0.jpg" # Ruta de fondo de pantalla por defecto en Windows
    }

    # Cargar la imagen de fondo actual
    $backgroundImage = [System.Drawing.Image]::FromFile($wallpaperPath)

    # Crear una nueva imagen con la resolución de pantalla
    $resizedImage = New-Object System.Drawing.Bitmap($screenWidth, $screenHeight)
    $graphics = [System.Drawing.Graphics]::FromImage($resizedImage)
    $graphics.DrawImage($backgroundImage, 0, 0, $screenWidth, $screenHeight)

    # Convertir el color hexadecimal a System.Drawing.Color
    $r = [Convert]::ToInt32($fontColor.Substring(0, 2), 16)
    $g = [Convert]::ToInt32($fontColor.Substring(2, 2), 16)
    $b = [Convert]::ToInt32($fontColor.Substring(4, 2), 16)
    $color = [System.Drawing.Color]::FromArgb($r, $g, $b)

    # Superponer el texto en la imagen redimensionada
    $font = New-Object System.Drawing.Font("Arial", $fontSize) # Tamaño del texto
    $brush = New-Object System.Drawing.SolidBrush($color) # Color del texto
    $darkGrayBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(150, 46, 46, 46)) # Gris oscuro semitransparente
    $graphics.FillRectangle($darkGrayBrush, 0, 0, $resizedImage.Width, $resizedImage.Height) # Fondo gris oscuro semitransparente
    $graphics.DrawString($infoText, $font, $brush, 10, 10)
    
    try {
        $filePath = "$env:USERPROFILE\Desktop\system_info_wallpaper.png"
        $resizedImage.Save($filePath, [System.Drawing.Imaging.ImageFormat]::Png)
        $saveMessage = if ($language -eq "es") { "La imagen ha sido guardada exitosamente." } else { "The image has been saved successfully." }
        Write-Host $saveMessage
        return $filePath
    } catch {
        $saveErrorMessage = if ($language -eq "es") { "Error al guardar la imagen: $_" } else { "Error saving the image: $_" }
        Write-Host $saveErrorMessage
        return $null
    } finally {
        $graphics.Dispose()
        $resizedImage.Dispose()
    }
}

# Si el parámetro es 'setfondo', configurar el fondo de pantalla directamente
if ($args[0] -eq "setfondo") {
    $filePath = Create-Wallpaper
    if ($filePath) {
        Set-Wallpaper -Path $filePath
        $setWallpaperMessage = if ($language -eq "es") { "El fondo de pantalla ha sido actualizado sin confirmación." } else { "The wallpaper has been updated without confirmation." }
        Write-Host $setWallpaperMessage
    }
    exit
}

# Si el parámetro es 'texto', configurar el tamaño del texto
if ($args[0] -eq "texto" -and $args.Length -eq 2) {
    $fontSize = [int]$args[1]
    $filePath = Create-Wallpaper -fontSize $fontSize
    if ($filePath) {
        Set-Wallpaper -Path $filePath
        $textSizeMessage = if ($language -eq "es") { "El fondo de pantalla ha sido actualizado con tamaño de texto $fontSize." } else { "The wallpaper has been updated with text size $fontSize." }
        Write-Host $textSizeMessage
    }
    exit
}

# Si el parámetro es 'color', configurar el color del texto
if ($args[0] -eq "color" -and $args.Length -eq 2) {
    $fontColor = $args[1]
    $filePath = Create-Wallpaper -fontColor $fontColor
    if ($filePath) {
        Set-Wallpaper -Path $filePath
        $textColorMessage = if ($language -eq "es") { "El fondo de pantalla ha sido actualizado con color de texto $fontColor." } else { "The wallpaper has been updated with text color $fontColor." }
        Write-Host $textColorMessage
    }
    exit
}

# Preguntar al usuario si desea establecer la imagen como fondo de pantalla
$promptMessage = if ($language -eq "es") { "¿Desea establecer esta imagen como fondo de pantalla? (s/n) " } else { "Do you want to set this image as wallpaper? (y/n) " }
$response = Read-Host $promptMessage

if ($response -eq "s" -or $response -eq "y") {
    $filePath = Create-Wallpaper
    if ($filePath) {
        Set-Wallpaper -Path $filePath
        $wallpaperUpdatedMessage = if ($language -eq "es") { "El fondo de pantalla ha sido actualizado." } else { "The wallpaper has been updated." }
        Write-Host $wallpaperUpdatedMessage
    }
} else {
    $wallpaperNotChangedMessage = if ($language -eq "es") { "El fondo de pantalla no ha sido cambiado." } else { "The wallpaper has not been changed." }
    Write-Host $wallpaperNotChangedMessage
}
