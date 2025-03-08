# Solicitar dirección IP y puertos al usuario
$IpAddress = Read-Host -Prompt "Introduce la dirección IP (por defecto: 192.168.1.5)"
$PortConnect = Read-Host -Prompt "Introduce el puerto para conectar (por defecto: 40621)"

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
    # Solicitar puerto para emparejar
    $PortPair = Read-Host -Prompt "Introduce el puerto para emparejar (por defecto: 40063)"
    if (-not $PortPair) {
        $PortPair = 40063
    }
    
    # Ejecutar el comando adb pair
    $pairCommand = "adb pair ${IpAddress}:$PortPair"
    Invoke-Expression $pairCommand
    Write-Host "Comando ejecutado: $pairCommand"
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

write-Host "*************************************************"
write-Host "Lista de Dispositivos"
adb devices
write-Host "*************************************************"
