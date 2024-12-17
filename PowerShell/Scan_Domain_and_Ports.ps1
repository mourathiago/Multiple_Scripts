# Caminho para o arquivo de subdomínios externos
$SubdomainFile = "subdomains.txt"  # Alterar o nome do arquivo conforme necessário

# Lista de portas a serem verificadas
$PortsToCheck = @(80, 443, 8080, 8443)  # Adicione portas adicionais conforme necessário

# Função para resolver um domínio e subdomínios
function Test-Domain {
    param (
        [string]$domain
    )
    try {
        $resolvedIP = [System.Net.Dns]::GetHostAddresses($domain) | Select-Object -First 1
        if ($resolvedIP) {
            Write-Output "$domain - Resolvido para $resolvedIP"
            return $resolvedIP
        } else {
            Write-Output "$domain - Não resolvido"
            return $null
        }
    } catch {
        Write-Output "$domain - Erro ao resolver"
        return $null
    }
}

# Função para verificar se uma porta específica está aberta
function Test-Port {
    param (
        [string]$IP,
        [int]$Port
    )
    $TCPConnection = New-Object System.Net.Sockets.TcpClient
    try {
        $TCPConnection.Connect($IP, $Port)
        Write-Output "Porta $Port está aberta em $IP"
    } catch {
        Write-Output "Porta $Port está fechada em $IP"
    } finally {
        $TCPConnection.Close()
    }
}

# Função principal para escanear domínio e subdomínios
function Scan-DomainAndPorts {
    param (
        [string]$domain
    )
    
    # Testa o domínio principal
    $domainIP = Test-Domain -domain $domain
    if ($domainIP) {
        # Verifica portas no domínio principal
        foreach ($port in $PortsToCheck) {
            Test-Port -IP $domainIP -Port $port
        }
    }

    # Carrega subdomínios a partir do arquivo
    if (Test-Path $SubdomainFile) {
        $subdomains = Get-Content -Path $SubdomainFile
        foreach ($subdomain in $subdomains) {
            $fullDomain = "$subdomain.$domain"
            $subdomainIP = Test-Domain -domain $fullDomain
            if ($subdomainIP) {
                # Verifica portas no subdomínio
                foreach ($port in $PortsToCheck) {
                    Test-Port -IP $subdomainIP -Port $port
                }
            }
        }
    } else {
        Write-Output "Arquivo de subdomínios não encontrado: $SubdomainFile"
    }
}

# Executa o script
$domain = Read-Host -Prompt "Digite o domínio principal para o scan"
Scan-DomainAndPorts -domain $domain
