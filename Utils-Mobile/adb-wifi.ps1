# Para Ejecutar
# powershell -ExecutionPolicy Bypass -File "./adb-wifi.ps1"
#
# Definir los archivos donde se almacenarán los puertos
$PortFilePath = "ultimo_puerto_conexion.txt"
$PairPortFilePath = "ultimo_puerto_emparejamiento.txt"

# Leer el último puerto de conexión almacenado si existe
if (Test-Path $PortFilePath) {
    $PortConnect = Get-Content $PortFilePath
} else {
    $PortConnect = 40621 # Valor por defecto
}

# Leer el último puerto para emparejar almacenado si existe
if (Test-Path $PairPortFilePath) {
    $PortPair = Get-Content $PairPortFilePath
} else {
    $PortPair = 40063 # Valor por defecto
}

# Solicitar dirección IP y puerto al usuario
$IpAddress = Read-Host -Prompt "Introduce la dirección IP (por defecto: 192.168.1.5)"
$PortConnect = Read-Host -Prompt "Introduce el puerto para conectar (por defecto: $PortConnect)"

# Asignar valores por defecto si no se introducen
if (-not $IpAddress) {
    $IpAddress = "192.168.1.5"
}
if (-not $PortConnect) {
    $PortConnect = 40621
}

# Menú de opciones
Write-Host "Seleccione una opción:"
Write-Host "1: Emparejar (pair)"
Write-Host "2: No emparejar, solo conectar (connect)"
$option = Read-Host -Prompt "Ingrese el número de la opción deseada (1 o 2)"

if ($option -eq "1") {
    # Leer el último puerto para emparejar (opcional)
    $PortPair = Read-Host -Prompt "Introduce el puerto para emparejar (por defecto: $PortPair)"
    if (-not $PortPair) {
        $PortPair = 40063
    }
    
    # Ejecutar el comando adb pair
    $pairCommand = "adb pair ${IpAddress}:$PortPair"
    Invoke-Expression $pairCommand
    Write-Host "Comando ejecutado: $pairCommand"
    
    # Guardar el puerto de emparejamiento utilizado en el archivo
    $PortPair | Out-File -FilePath $PairPortFilePath -Force
}
elseif ($option -eq "2") {
    Write-Host "No se realizará emparejamiento."
}
else {
    Write-Host "Opción no válida. Por favor, ejecute el script nuevamente."
    exit
}

# Ejecutar el comando adb connect
$connectCommand = "adb connect ${IpAddress}:$PortConnect"
Invoke-Expression $connectCommand
Write-Host "Comando ejecutado: $connectCommand"

# Guardar el puerto de conexión utilizado en el archivo
$PortConnect | Out-File -FilePath $PortFilePath -Force

write-Host "*************************************************"
write-Host "Lista de Dispositivos"
adb devices
write-Host "*************************************************"
