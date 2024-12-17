# Define a lista de endereços IP
$ips = @(
    "192.168.101.193",
    "192.168.101.194",
    "192.168.102.195",
    "192.168.102.196"
)

# Itera sobre cada IP e executa o traceroute
foreach ($ip in $ips) {
    Write-Host "Executando traceroute para $ip" -ForegroundColor Cyan
    # Executa o comando tracert com os parâmetros desejados
    tracert -h 15 $ip
    Write-Host "----------------------------------------"
}
